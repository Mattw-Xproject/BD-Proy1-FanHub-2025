# BD-Proy1-FanHub-2025
FanHub, diseñó de una base de  datos robusta y bien estructurada bajo las mejores prácticas de bases de datos para asegurar una transición fluida desde el modelo conceptual(EER) al modelo relacional (SQL).
# [1.0.0] - 2025-12-27 

En esta sección se documentan las tres etapas clave de nuestra metodología de diseño. Este flujo nos permitió validar primero la lógica de negocio y finalmente alcanzar la excelencia gráfica necesaria para un plano técnico de base de datos.

## **1\. Fase de Prototipado: Diagram-as-Code (Mermaid)**

Esta es nuestra "fuente de la verdad" lógica. Aquí utilizamos **Mermaid.js** junto con el sistema de versiones de **GitHub** para iterar rápidamente. En esta fase, el enfoque fue resolver la estructura de entidades y las relaciones sin preocuparnos por la estética final.

**Propósito:** Validar cardinalidades, atributos y dependencias de entidades débiles mediante código versionable.

[Diagram-as-Code EER V1](https://github.com/Mattw-Xproject/BD-Proy1-FanHub-2025/blob/5185bc043092f1d3ca7115e5e8753087106ba7e8/FanHUB_Diagrama-Entidad-Relaci%C3%B3n-Extend-2025-12-28.mmd)![(DaC)](https://github.com/user-attachments/assets/cf0b7c30-ff37-451a-a436-93f38e735605)

## [2.0.0] - 2025-12-28 

## **2\. Fase de Refinamiento: Jerarquías y Triángulos ISA**

Una vez consolidada la base, pasamos a modelar las relaciones de herencia y especialización. En esta etapa implementamos la notación de **Trapecio Invertido** para los arcos de especialización, permitiendo visualizar claramente las restricciones de participación (Total/Parcial) y disyunción (Disjunta/Solapada).


**Propósito:** Definir la arquitectura de subtipos para Publicaciones (Video, Imagen, Encuesta) y Usuarios (Creadores).

[Inheritance, Subtypes & Supertypes EER V2](https://github.com/Mattw-Xproject/BD-Proy1-FanHub-2025/blob/5185bc043092f1d3ca7115e5e8753087106ba7e8/Modelo%20E_R-E%20V2/FanHUB_Diagrama-Entidad-Relaci%C3%B3n-Extend-V2-2025-12-28.mmd)![(ISA)](https://github.com/user-attachments/assets/02ad03ff-443c-44bd-a07a-be9711882445)

## [3.0.0] - 2025-12-29 

## **3\. Fase Final: Plano Técnico (Adobe Illustrator / Draw.io)**

El resultado final es un diagrama retocado donde se aplican los **arcos de diagramación EER** con precisión milimétrica. En esta versión se abandonan las limitaciones de las herramientas automáticas para cumplir con la normativa académica: uso de líneas dobles para participación total, arcos de especialización curvos y una diagramación espacial optimizada para la lectura humana.

**Propósito:** Entrega del artefacto final como manual de referencia para la implementación física en SQL.

| Versión | Herramienta | Enfoque |
| :---- | :---- | :---- |
| **v1.0 (DaC)** | Mermaid \+ GitHub | Lógica y Versatilidad |
| **v2.0 (ISA)** | Mermaid Advanced | Jerarquías y Especialización |
| **v3.0 (Draw)** | Adobe Illustrator | Estética Técnica y Rigor Académico |

---
[Final Diagram Illustrator Edition V3](https://github.com/Mattw-Xproject/BD-Proy1-FanHub-2025/blob/5185bc043092f1d3ca7115e5e8753087106ba7e8/Modelo%20E_R-E%20V3%20FINAL/img/FanHub%20(Modelo%20ER-E)-03.svg?raw=true)
<img width="2481" height="3508" alt="(Draw)" src="https://github.com/user-attachments/assets/ce0f7268-b15b-4b8d-8fbc-f47c59d4e720" />
## [4.0.0] - 2025-12-29 

**4\. Leyenda de colores semánticos y guía de notación visual para el "Diagram as Code" EER V4**

[Leyenda_Diagrama-Entidad-Relación-Extendido-V4](https://github.com/Mattw-Xproject/BD-Proy1-FanHub-2025/blob/bd12bb84ddc34080cff67d39af01c529dc86df7f/Modelo%20E_R-E%20V2/FanHUB_Diagrama-Entidad-Relaci%C3%B3n-Extend-V2-2025-12-28.mmd)![Leyenda-DaC](https://github.com/Mattw-Xproject/BD-Proy1-FanHub-2025/blob/bd12bb84ddc34080cff67d39af01c529dc86df7f/Modelo%20E_R-E%20V2/img/Leyenda_Diagrama-Entidad-Relaci%C3%B3n-Extendido-V4-2025-12-28.svg)
