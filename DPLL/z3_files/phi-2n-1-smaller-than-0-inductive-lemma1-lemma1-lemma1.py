from sys import path
path.insert(0,"/ubc/cs/home/y/yanpeng/project/ACL2/smtlink/z3_interface")
from ACL2_translator import to_smt, Q
s = to_smt()
N_MINUS_2=s.isReal("N_MINUS_2")
hypothesis=False
conclusion=True
s.prove(hypothesis, conclusion)
