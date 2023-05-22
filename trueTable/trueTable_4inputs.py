# TABLA DE VERDAD PARA EXPRESIONES DE MAX 4 ENTRADAS

# Cambiar las variables expresion_1 y expresion_2 con tus expresiones o funciones booleanas

def nand(a,b):
    return not(a and b)

def nor(a,b):
    return not(a or b)

def xor(a,b):
    return 1 if a != b else 0

a = b = c = d = False

red_code = "\033[91m"
green_code = "\033[92m"
blue_code = "\033[94;1m"
yellow_code = "\033[93;1m"

reset_code = "\033[0m"


# Imprime el encabezado de la tabla de verdad
print(f"{blue_code}--------------------------- Tabla de verdad ---------------------------------")
print("-----------------------------------------------------------------------------")
print(f"{yellow_code} \td\tc\tb\ta\t|\ts1\ts2\t|\t?")
print(f"{blue_code}-----------------------------------------------------------------------------{reset_code}")
for i in range(16):
    if i != 0:
        a = not a
        
        b = not b if ((i % 2) == 0) else b
        c = not c if ((i % 4) == 0) else c
        d = not d if ((i % 8) == 0) else d
        
    combinacion = f"{int(d)}\t{int(c)}\t{int(b)}\t{int(a)}"
    
    
    # ---------------------------------- Original ------------------------------------
    # Escribe la expresion original:
    # EJEMPLO:
    # expresion_1 = ((a or b) and not (a or b)) or (((a and not c and d) or not (a or b)) and not (a or b))
    expresion_1 = (not((not(a or b)) and (not c or not d))) or ((not c or not d) and (a or b))
    # ----------------------------------------------------------------------------------    
    # ---------------------------------- Convertida ------------------------------------
    # Escribe la expresion equivalente:    
    # EJEMPLO:
    # expresion_2 = not a and not b
    expresion_2 = not(nor(not(nor(not(nor(a,b)), nor(not c, not d))), nor(nor(not c, not d), nor(a,b))))
    
    # -----------------------------------------------------------------------------------

    
    # Imprime la tabla de verdad
    resultado = f"{red_code}0{reset_code}" if expresion_1!=expresion_2 else f"{green_code}1{reset_code}"
    print(f"{i}.\t{combinacion}\t{blue_code}|{reset_code}\t{int(expresion_1)}\t{int(expresion_2)}\t{blue_code}|{reset_code}\t{resultado}")
    
    