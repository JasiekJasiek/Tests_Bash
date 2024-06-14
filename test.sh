# zatrzymaj na pierwszy błędnym teście
# set -e

PROGRAM=$1
FOLDER_Z_TESTAMI=$2
NUMER_TESTU=1
LICZBA_WSZYSTKICH_TESTOW=$(ls -1 ./${FOLDER_Z_TESTAMI}/in/*.in | wc -l)

g++ ${PROGRAM}.cpp -o ./${PROGRAM} --std=c++11 -O2 -g

for wejscie in ./${FOLDER_Z_TESTAMI}/in/*.in
do
    echo -n -e "\r Test (${NUMER_TESTU}/${LICZBA_WSZYSTKICH_TESTOW}) ... " 
    
    wyjscie=$(echo ${wejscie} | sed "s/in/out/g")
    wyjscie=$(echo ${wyjscie} | sed "s/out/my/g")
    odpowiedz=$(echo ${wyjscie} | sed "s/my/out/g")
    folder_z_wyjsciem=$(dirname "${wyjscie}")
    mkdir -p "${folder_z_wyjsciem}"

    START=$(date +%s.%N)
    ./${PROGRAM} < $wejscie > $wyjscie
    END=$(date +%s.%N)
    WYJSCIE_DIFFA=$(diff $wyjscie $odpowiedz -Z)
    WYNIK_DIFFA=$?
    
    TIME=$(echo "$END - $START" | bc | xargs printf "%.2f")

    if [[ WYNIK_DIFFA -eq 0 ]]; then
        echo -n "OK (Czas: ${TIME}s)"
    else
        echo -e "\n${wejscie}: Zla odpowiedz"
        echo "${WYJSCIE_DIFFA}"
        exit 1
    fi
    NUMER_TESTU=$(($NUMER_TESTU+1))
done
echo ""
