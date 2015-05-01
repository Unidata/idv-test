import math, operator
from pyhiccup.core import html
from html5print import HTMLBeautifier
from os import listdir
from os.path import isfile, join, splitext, basename
from PIL import ImageChops
from PIL import Image

IDV_PATH = "/home/idv/"
TEST_PATH = IDV_PATH + "test-output/"
BUNDLE_PATH = IDV_PATH + "idv-test/bundles/"
BASE_PATH = IDV_PATH + "test-output/baseline/"

# http://code.activestate.com/recipes/577630-comparing-two-images/
def rmsdiff(i1, i2):
    "Calculate the root-mean-square difference between two images"
    if (isfile(i1) and isfile(i2)): 
        im1, im2 = Image.open(i1), Image.open(i2)
        diff = ImageChops.difference(im1, im2)
        h = diff.histogram()
        sq = (value*(idx**2) for idx, value in enumerate(h))
        sum_of_squares = sum(sq)
        rms = math.sqrt(sum_of_squares/float(im1.size[0] * im1.size[1]))
        return rms
    else:
        return 0

def readoutput(file):
    "Read file intro string"
    data = 'EMPTY ' + file
    if (isfile(file)):
        with open (file, "r") as myfile:
            data = myfile.read()
    return data


def process(bundle):
    "Process the test output of the given bundle"
    bname = splitext(basename(bundle))[0]
    result =[("./baseline/" + f,
             "./results/" + f,
             rmsdiff(TEST_PATH + "baseline/" + f, TEST_PATH + "results/" + f))
        for f in listdir(BASE_PATH) if f.startswith(bname + "_view")]
    return result

    
baseline = [(f,
             readoutput(TEST_PATH + "results/" + splitext(f)[0] + ".xidv.out"),
             process(f))
             for f in listdir(BUNDLE_PATH) if isfile(join(BUNDLE_PATH,f)) ]

# sorting on first img, even if there are multiple images/bundle    
sortimgs = sorted(baseline, key=lambda img: img[2][0][2])


data = [[
        ['hr'],
        ['h1', x[0]],
        ['table',
        ['tr', ['td', x[1].replace("\n","<br />")]],
        ['tr', [['td',['h2', "expected"]],['td',['h2', "actual"]]]], 
        [['tr',
          [['td', ['img', {'src' : i[0]}]],
           ['td', ['img', {'src' : i[1]}]]]]
              for i in x[2]]]]
         for x in sortimgs[::-1]]
            
myhtml = html(data)

pretty = HTMLBeautifier.beautify(myhtml, 2)

f = open(TEST_PATH + 'compare.html','w')
f.write(pretty)
f.close()
