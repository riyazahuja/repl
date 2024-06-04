import os
import subprocess
import json
import re

def get_file_paths(r="benchmark/data"):
  leanfiles = []
  for root,dirs,files in os.walk(r):
    for f in files:
      if f.endswith(".lean"):
        name = os.path.join(root,f)
        leanfiles.append(name)
  return leanfiles

def get_json(path, r="benchmark/data"):
  outfile = os.path.join("benchmark/raw",path[len(r)+1:-5]+'.json')
  try:
    os.makedirs(outfile)
    os.rmdir(outfile)
  except:
    pass
  cmd = f'''echo '{{"path": "{path}", "allTactics": true}}' | lake exe repl > {outfile}'''
  subprocess.run([cmd],shell=True, text=True)
  return outfile

def align(text, num):
  space = ' '*num
  s = text.split('\n')
  output = ""
  for item in s:
    output = output+space+item
    if item != s[-1]:
      output = output+'\n'
  return output


def parse_json(lean_path,json_path):
  #want to output a list of annotated theorems (each as a string)
  with open(lean_path, 'r') as file:
    content = file.readlines()

  with open(json_path,'r') as file:
    data_raw = json.load(file)['tactics']

  data = {}
  for item in data_raw:
    goal = item['goals']
    pos = item['pos']
    #end = item['endPos']['line']
    data[pos['line']-1] = (pos['column']-1,goal)

  output = ""

  for l in range(len(content)):
    if l in data.keys():
      line = content[l]
      col_num, goal = data[l]
      aligned_comment = align(f'/-\n{goal}\n-/',col_num)
      annotated = '\n'+aligned_comment+'\n'+line
    else:
      annotated = content[l]
    output = output + annotated

  return output


#def get_theorems(content):
#  return ['theorem'+item for item in content.split('theorem')]

def get_theorems(lean_content):
    # This regex matches the pattern of a theorem declaration to the start of its proof
    # It assumes that theorem proofs end where another starts or at the end of the content.
    pattern = re.compile(r"(theorem\s+\w+\s*[^:=]*:.*?)(?=theorem|\Z)", re.DOTALL)

    # Find all theorems using the regex pattern
    theorems = pattern.findall(lean_content)
    return theorems


files = get_file_paths()[0]
for f in [files]:
  json_file = get_json(f)
  annotated_file = parse_json(f,json_file)
  theorems = get_theorems(annotated_file)
  for t in theorems:
    print(t)
    print('\n\n')








