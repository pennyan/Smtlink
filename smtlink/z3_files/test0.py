from sys import path
path.insert(0,"/ubc/cs/home/y/yanpeng/project/ACL2/smtlink/z3_interface")
from ACL2_translator import to_smt
s = to_smt()
X=s.isReal("X")
hypothesis=True
conclusion=s.equal(s.plus(X,X),(lambda var0:s.times(2,var0))(X))
s.prove(hypothesis, conclusion)