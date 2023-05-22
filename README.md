# **Diseño digital**

Este repositorio contiene programas que podrían ayudar a solucionar problemas relacionados con *álgebra booleana, diseño digital, VHDL, etc*.

En cada carpeta se encuentra la descripción del funcionamiento de los programas, así como las instrucciones necesarias para ejecturar cada una de estas.

## **Contenido**

Hasta el momento el repositorio cuenta con los siguientes programas:

- [Tablas de verdad](trueTable/) :  Genera una tabla de verdad de máximo 4 entradas. Además, es capaz de comparar hasta dos expresiones booleanas.

- [Sumador con acarreo anticipado](carry-ahead-adder/) : **(DE10-Lite - FPGA)**
Es un sumador hecho en ***VHDL***. Consta de 2 entradas en BCD de 4 bits y una entrada para el acarreo. La salida también es en BCD de *5 bits* y vectores de *7 bits* para representar la suma en *displays de 7 segmentos*.