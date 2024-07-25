# Fo Coefficient Calculator for Image Elaboration System
![Apache](https://img.shields.io/badge/VHDL-%23D22128.svg?style=flat-square)
![ModelSim](https://img.shields.io/badge/ModelSim-4479A1?style=flat-square)
![PHP](https://img.shields.io/badge/Vivado-%e4e796.svg?style=flat-square)
![Python](https://img.shields.io/badge/Python-3776AB.svg?style=flat-square&logo=python&logoColor=yellow)

University project for **Electronics and Communication Systems** course (MSc Computer Engineering at University of Pisa, A.Y. 2023-24)   

In an **Image Elaboration System**, it is necessary to calculate the **Fo Coefficient**, with the following formula:   
    **fo = α · y(i − 1, j) + (1 − α) · y(i, j)**   
where:
- y(i − 1, j) and y(i, j) are pixels of the matrix y, which represents an image;   
- y(i, j) ∈ I, y(i, j) ∈ [0, 255];    
- α is a parameter chosen by the user. α ∈ (0, 1)   

The goal of this Project is to design a digital circuit for implementing such operation.  
- The value **α** in fixed-point arithmetic is represented on 3-bits.     
- The output **f0** is represented in 12 fixed-point arithmetic.   

The Schema of the circuit, obtained through Vivado’s RTL analysis is the following:

![Circuit Schema](./docs/device_architecture_Vivado.PNG)

## Structure of the repository

```
Fo-Coefficient-Calculator-for-Image-Elaboration-System
│
├── conf_files
│
├── docs
│
├── modelsim
│
├── script
│   └── results
│
├── src
│
├── tb
│
└── vivado
```

## Author
- [Fabrizio Lanzillo](https://github.com/FabrizioLanzillo)