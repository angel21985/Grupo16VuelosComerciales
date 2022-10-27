# VUELOS COMERCIALES

## _Proyecto Grupal HENRY Octubre 2022_

<p align="center">
<img src="https://s3.amazonaws.com/arc-wordpress-client-uploads/infobae-wp/wp-content/uploads/2018/01/17155044/Avion-despegando.jpg"   
height="400">
</p>

El Departamento de Transporte de Estados Unidos (U.S. DOT) está interesado en conocer información relacionada al tráfico aéreo a nivel global, con el fin de poder monitorear y definir proyectos acordes a la situación actual y además de poder complementarlo con una visión completa de lo que ha pasado históricamente. Dentro de la información mínima que necesita saber el Departamento, está la cancelación de vuelos y los atrasos de éstos.


## **Objetivos Propuestos**

- **Definir KPI'S**, tales como reducir la cancelación de vuelo en un 10% en cierto período de tiempo, disminuir o aumentar la flota para ocupar cierto porcentaje de mercado, reducir en cierto porcentaje los destinos poco frecuentes, etc.

- **Generar mapas** sobre concentración de vuelos, destinos frecuentes, rutas frecuentes, etc.

- **Definir alcances**: años a considerar, aerolíneas a considerar, países/continentes a considerar, etc.

- **Definir tablas de hechos y dimensiones** según la información a utilizar.

- **Crear dashboards** que contengan información clave y útil.

## **Herramientas Principales A Utilizar**

- [AWS](https://aws.amazon.com/es/free/?trk=eb709b95-5dcd-4cf8-8929-6f13b8f2781f&sc_channel=ps&s_kwcid=AL!4422!3!561348326837!e!!g!!aws&ef_id=Cj0KCQjwteOaBhDuARIsADBqRegg2z6og-ihE1zN8m4lx2g-cfBe1qAPpqv56uqPQKVNbL5mq7dWSYQaAk0xEALw_wcB:G:s&s_kwcid=AL!4422!3!561348326837!e!!g!!aws&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all)
- [PYTHON](https://www.python.org/)
- [POWER BI](https://powerbi.microsoft.com/es-es/)
- [MySQL](https://www.mysql.com/)

## **Procedimiento Planteado**

Dsede la parte técnica, se realizó una búsqueda de fuentes de datos, datasets en formato CSV. Esos csv fueron almacenados en un bucket de S3. Amazon Simple Storage Service (Amazon S3) es un servicio de almacenamiento de objetos que ofrece escalabilidad, disponibilidad de datos, seguridad y rendimiento líderes en el sector. Clientes de todos los tamaños y sectores pueden almacenar y proteger cualquier cantidad de datos para prácticamente cualquier caso de uso, como los lagos de datos, las aplicaciones nativas en la nube y las aplicaciones móviles. Gracias a las clases de almacenamiento rentables y a las características de administración fáciles de usar, es posible optimizar los costos, organizar los datos y configurar controles de acceso detallados para cumplir con requisitos empresariales, organizacionales y de conformidad específicos. Se necesitó la creación de una nueva base de datos en MySQL, dentro de RDS para almacenar futuras tablas vacías que almacenarán los datos normalizados. El siguiente paso fue con la ayuda de BOTO3 en S3 crear un script para que podamos trabajar de manera más cómoda los archivos en PYTHON. Poder limpiar los dataframes, normalizarlos.
Luego de que logramos normalizar los dataframes, el siguiente paso fue transportarlos a MySQL donde nos esperaban las tablas vacías para ser llenadas con estos dataframes. 
En la etapa final de este proceso se utilizó las herramientas GLUE, CRAWLERS y JOB para generar un WORKFLOW en AWS. Este WORKFLOW es la herramienta que nos permitirá que las nuevas tablas ingresadas puedan ser guardadas en nuevo bucket de S3 para seguir trabajando de manera ordenada con todos los datos alamacenados.

Entre objetivos generales planteados para el proyecto se tomó en cuenta:

- Monitorear y definir proyectos acordes a la situación actual.

- Poder complementarlo con una visión completa de lo que ha pasado históricamente.

-Tener conocimiento de la cancelación de vuelos y los atrasos de éstos.

Los indicadores que se propusieron estudiar para evaluar en el proyecto:

- Reducir la cantidad de vuelos demorados en un 20% por año hasta alcanzar por lo menos el 5% de los vuelos anuales.

- Reducir las cancelaciones de vuelos entre un 10% a 15% no causados por fenómenos climáticos.

- Disminuir la desocupación de asientos en un 10% por año hasta lograr bajar un 50% de la desocupación.

- Disminuir el tiempo de retraso en la salida de vuelos en por lo menos un 30% por año.


## Links    

 - [DATASETS](https://github.com/EzequielCarena/Grupo16VuelosComerciales/tree/main/DataCleaning/dirty_csv)
 - [Data Cleaning](https://github.com/EzequielCarena/Grupo16VuelosComerciales/tree/main/DataCleaning/dataCleaning)
 - [Data Cleaning 2](https://github.com/EzequielCarena/Grupo16VuelosComerciales/tree/main/DataCleaning/clean_csv)
 - [Visualizaciones](https://github.com/EzequielCarena/Grupo16VuelosComerciales/)

## Autores

- [@santigll](https://www.github.com/santigll)
- [@angel21985](https://www.github.com/angel21985)
- [@Maxip86](https://www.github.com/Maxip86)
- [@EzequielCarena](https://www.github.com/EzequielCarena)
