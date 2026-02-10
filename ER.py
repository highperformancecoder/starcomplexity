#import ecolab
#print(ecolab.device())

from starComplexity import starC
nodes=500
starC.generateElementaryStars(nodes)

from random import randint

with open(f'ER-{nodes}.csv', 'w') as out:
    print('id,C,starBar,starBarABC',file=out)
    for i in range(1000):
        r=starC.randomERGraph(nodes, randint(0,(nodes*(nodes-1))//2))
        print(i,r.complexity(),r.starComplexity(),r.starComplexityABC(),file=out,sep=',',flush=True)
        
