#!/bin/sh

# I apologize for what you're about to see

# Initialize some variables
code="+++++++++++++[>++++++++<-]>."
#code="+++++++++++++++++++++++++++++++++."
memory=""
ip=1
dp=1 # Data pointer

i=1
while [ $i -le 30000 ]; do
    export memory="${memory}0;"
    export i=$(($i+1))
done

# Define function for adding/subtracting a thing in the memory
add() {
    array=$1
    index=$2
    y=$3

    
    x=$(echo $array | cut -d ';' -f $index)
    x=$(( (x+y)%256 ))
    if [ $x -lt 0 ]; then
        x=$(( x+256 ))
    fi

    if [ $index -eq 1 ]; then
        array_before=""
    else
        array_before="$(echo $array | cut -d ';' -f -$(( ${index}-1 )));"
    fi
    array_after=$(echo $array | cut -d ';' -f $(( ${index}+1 ))- )
    array="${array_before}${x};${array_after}"

    echo $array
}

stack=""
jump_table=""
sp=1
i=1
while [ $i -le ${#code} ]; do
    export jump_table="${jump_table}1;"
    export i=$(( ${i}+1 ))
done
i=1
while [ $i -le ${#code} ]; do
    if [ $(echo $code | cut -c $i) = "[" ]; then
        export stack="${stack}/${i}"
        export sp=$(( ${sp}+1 ))
    elif [ $(echo $code | cut -c $i) = "]" ]; then
        jump_table=$(add $jump_table $i $(basename ${stack}))
        jump_table=$(add $jump_table $(echo $jump_table | cut -d ';' -f $i) ${i})
        export sp=$(( ${sp}-1 ))
        export stack=$(echo $stack | cut -d '/' -f 1-${sp})
    fi
    export i=$(( ${i}+1 ))
#    echo $jump_table
done

# Main loop
while [ $ip -le ${#code} ]; do
    instruction=$(echo $code | cut -c $ip)

    case $instruction in
        "+")
            memory=$(add $memory $dp 1)
            ;;
        "-")
            memory=$(add $memory $dp -1)
            ;;
        ">")
            dp=$(( (${dp}+1) % 30000 ))
            ;;
        "<")
            dp=$(( ${dp}-1 ))
            if [ $dp -lt 1 ]; then
                dp=30000
            fi
            ;;
        ",")
            echo -n "Input: "
            read -r char
            char=$(echo $char | cut -c 1)
            char=$(printf "%d\n" \'${char})

            if [ $dp -eq 1 ]; then
                memory_before=""
            else
                memory_before="$(echo $memory | cut -d ';' -f -$(( ${dp}-1 )));"
            fi
            memory_after=$(echo $memory | cut -d ';' -f $(( ${dp}+1 ))- )
            memory="${memory_before}${char};${memory_after}"
            ;;
        ".")
            printf "\x$(printf "%x" $(echo $memory | cut -d ';' -f $dp))"
            ;;
        "[")
            if [ $(echo $memory | cut -d ';' -f $dp) = 0 ]; then
                ip=$(( $(echo $jump_table | cut -d ';' -f $ip)-1 ))
            fi
            ;;
        "]")
            if [ $(echo $memory | cut -d ';' -f $dp) != 0 ]; then
                ip=$(( $(echo $jump_table | cut -d ';' -f $ip)-1 ))
            fi
            ;;
    esac

    export ip=$(( ${ip}+1 ))
done

echo ""
