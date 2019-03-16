import os
import json
import numpy as np
from cntk.ops.functions import load_model

model = load_model("D:/home/site/wwwroot/trained_model")
postreqdata = json.loads(open(os.environ['req']).read())
a = postreqdata["a"]
b = postreqdata["b"]
result = model.eval({model.arguments[0]:[[a,b]]})
print(result)
response = open(os.environ['res'], 'w')
response.write(str(np.argmax(result)))
response.close()