#import ecolab
#print(ecolab.device())

from starComplexity import starC
nodes=22
maxStars=9
starC.restart(f'{nodes}-{maxStars}.ckpt');

with open(f'{nodes}-{maxStars}Post.csv','w') as out:
    print('id,g,links','*','bar{*}','bar{*}_{ABC}','C','C*','omega(g)',sep=',',file=out)
    id=0
    for i in starC.starMap.keys():
        c=starC.complexity(i)
        links=0
        num=0
        m=1
        for j in i:
            links+=bin(j).count('1')
            num+=m*j
            m*=1<<32
            

        symmStar=starC.symmStar(i)-1
        starUpperBound=starC.starUpperBound(i)-1
        starUpperBoundABC=starC.starUpperBoundABC(i)-1
        print(id,bin(num),links,symmStar,starUpperBound,starUpperBoundABC,c.complexity(),c.starComplexity(),starC.counts[i],starC.recipe[i],sep=',',file=out)
        if starUpperBoundABC<symmStar:
            print(symmStar,starUpperBound,starUpperBoundABC,starC.recipe[i],starC.ABCrecipe())
            print(starC.edges(i)())
        id+=1
