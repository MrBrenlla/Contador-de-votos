#!/bin/bash


#para dar formato
ROJO=`tput setaf 1`
VERDE=`tput setaf 2`
AMARILLO=`tput setaf 3`
RESET=`tput sgr0`
SUBR=`tput smul`


#para cálculos resultados
totalLineas=0
lineasDiferentes=0
porcentajeLineas=0
UNITS=("DynamicList" "StaticList")
MAIN_NAME=main

usage() { echo "Usage: $0 [-p <main|TestUnit>] [-v]" 1>&2; exit 1; }

# Comprobar parametros de entrada
VERBOSE=false
while getopts "p:v" opt; do
    case "$opt" in
      p)  MAIN_NAME=$OPTARG
          if [[ "$MAIN_NAME" != "main" && "$MAIN_NAME" != "TestUnit" ]]; then
            usage
          fi
          ;;
      v)
          VERBOSE=true
          echo VERBOSETRUE
          ;;
      *)
          usage
          ;;
    esac
done
MAIN="./"$MAIN_NAME
if [ "$MAIN_NAME" = "main" ]
then
  ficherosEntrada=("script_minimos/new" "script_minimos/vote" "script_minimos/illegalize1" "script_minimos/illegalize2")
  ficherosRef=("script_minimos/new_ref" "script_minimos/vote_ref" "script_minimos/illegalize1_ref" "script_minimos/illegalize2_ref")
else
  ficherosEntrada=("")
  ficherosRef=("script_test_unit/ref")
fi

# Funcion para comprobar la salida del programa
# Parametros de entrada:
#   - descripcion tipo de lista
#   - nombre unit a probar
#   - nombre unit a reemplazar
#   - salida verbosa
# Parametros de salida:
#   - Exito (1) o fallo (0) en la comprobacion
function check_output {
    LIST_TYPE_DESC=$1
    LIST_UNIT=$2
    VERBOSE=$3

    rm -f *.o *.ppu ${MAIN}

    for UNIT in ${UNITS[@]}
    do
        if grep -q ${UNIT} ${MAIN}.pas;
        then
            LIST_UNIT_TO_REPLACE=${UNIT}
        break
        fi
    done

    printf "${AMARILLO}Running script for ${LIST_TYPE_DESC}...${RESET}"

    if [ -n "${LIST_UNIT_TO_REPLACE}" ];
    then
        sed -i "s/${LIST_UNIT_TO_REPLACE}/${LIST_UNIT}/g" ${MAIN}.pas
    else
        allOK=0
        printf "\n${ROJO}Unit name incorrect. Allowed values are: ${UNITS[*]}\n\n"
        return ${allOK}
    fi

    printf "\n${AMARILLO}Compiling "$MAIN_NAME" program using ${LIST_TYPE_DESC}...${RESET}\n\n"

    fpc ${MAIN}

    if [ -f ${MAIN} ]
    then
        allOK=1
        printf "\n${AMARILLO}Checking "$MAIN_NAME" program output using ${LIST_TYPE_DESC}...\n${RESET}"
	    printf "\n${SUBR}Input file${RESET}                          ${SUBR}Result${RESET}  ${SUBR}Notes${RESET}\n"
      for index in ${!ficherosEntrada[*]}
	    do
        nombre=${ficherosEntrada[$index]}
        if [ "$nombre" != "" ]
        then
	    	    ficheroEntrada="$nombre".txt
        else
            ficheroEntrada=""
            nombre="script_test_unit/TestUnit"
            #nombre=$index
        fi
	    	ficheroReferencia=${ficherosRef[$index]}.txt
	    	ficheroSalida="$nombre"_${LIST_UNIT}.txt
	    	ficheroDiff="$nombre"_diff.txt
	    	${MAIN} $ficheroEntrada > $ficheroSalida
	    	diff -w -B -b -y --suppress-common-lines --width=100 $ficheroReferencia $ficheroSalida > $ficheroDiff
	    	iguales=$(stat -c%s $ficheroDiff)
        if [ "$ficheroEntrada" = "" ]; then
          ficheroEntrada="(no input file)"
        fi
	    	if [ ${iguales} -eq "0" ]
	    	then
	    		printf "%-35s %-12s %s\n" "$ficheroEntrada" "${VERDE}OK"  "${RESET}"
	    	else
	    		printf "%-35s %-12s %s\n" "$ficheroEntrada" "${ROJO}FAIL" "${RESET}Check ${ficheroReferencia} and ${ficheroSalida}"
	    		allOK=0
        	    if  ${VERBOSE}
    		    then
    		        printf '\nFile: %-39s | File: %s\n' $ficheroReferencia $ficheroSalida
    		        printf '=%.0s' {1..100}
    		        printf '\n'
        			cat ${ficheroDiff}
        			printf '\n'
          	    fi
	    	fi
	    	rm $ficheroDiff
	    done
    else
   		allOK=0
	    printf "\n${ROJO}Compilation failed${RESET}"
    fi
	printf "\n\n"
    return ${allOK}
}


#Comprobar que existen en path actual los ficheros output de referencia
#(sino, tal y como está el script da un OK a pesar de mostrar un error en el diff)
for file in ${ficherosRef[@]}
do
	if [ ! -f "${file}.txt" ]
	then
		printf "${ROJO}Please add the reference file ${file}.txt to the current path${RESET}\n"
		exit 1
	fi
done



check_output "Static List" "StaticList" ${VERBOSE}
STATIC_OK=$?

check_output "Dynamic List" "DynamicList" ${VERBOSE}
DYNAMIC_OK=$?


printf "${AMARILLO}Global result: "
if  [ ${STATIC_OK} -eq 1 ] && [ ${DYNAMIC_OK} -eq 1 ]
then
	printf "${VERDE}OK${RESET}"
else
	printf "${ROJO}FAIL${RESET}"
fi
printf "\n\n"
