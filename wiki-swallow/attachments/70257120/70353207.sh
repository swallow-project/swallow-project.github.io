#! /bin/bash



# how many lines to look back for labels
CONTEXT_SIZE=500

if [ -e debug.out ]
then
rm debug.out
fi

if [ -e debug.out2 ]
then
rm debug.out2
fi

debug-swallow-bylink.py > debug.out


while IFS=':' read -r field1 field2
do
#echo "F1: $field1 F2: $field2"
if [[ $field1 =~ .*Logical.* ]]
then NODE=$(echo $field2 | cut -f1 -d '|' | tr -d ' ' | sed 's/^0*//')
if [[ $NODE == '' ]] 
then NODE=0
fi
else
 if [[ ! $field1 =~ .*T.* ]]
then 
THREAD=$(echo $field1 | tr -d ' ')
PC=$(echo $field2 | tr -d ' ')
#echo "Tile $NODE, Thread $THREAD PC $PC"

if [ -e scmain_$NODE.xe ]
then 
CONTEXT=`xobjdump -d scmain_$NODE.xe | grep -B$CONTEXT_SIZE $PC | cat > context.out`
#echo $CONTEXT
INSTRUCTION=`tail -n1 context.out | sed 's/^ *//g'`
LABEL=`cat context.out | egrep  "[a-zA-Z0-9_-]*>:" | tail -n1`
if [[ $LABEL != "<_TouchRegisters>:" ]]
then 
echo "Tile $NODE Core $THREAD  Scope $LABEL  pc= $INSTRUCTION" | tee debug.out2
# | cat >> debug.out2
fi
fi
fi
fi

done < debug.out
#sort -g -k2 debug.out2
