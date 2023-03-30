# TPE-XML

En este trabajo se busca extraer y presentar datos e información acerca de los distintos
conductores de NASCAR que participaron en cierto año y en cierta competencia.
Para ello se utiliza la API oficial de NASCAR brindada por SportRadar (https://developer.sportradar.com/docs/read/racing/NASCAR_v3).

La API debe haber cambiado porque este TP ya no funciona :(

## Lenguajes usados
- XML
- XSLT
- XQuery
- XML Schema

## Ejecucion

Primero hay que setear la variable de entorno SPORTRADAR_API. Para ello:
- 1. Crear una nueva cuenta gratuita en el sitio Developers SportRadar(https://developer.sportradar.com/member/register)
- 2. Una vez creada la cuenta, crear una nueva “application”, con formato XML y luego crear una API Key para “NASCAR v3”.
- 3. Ejecutar el siguiente comando:

```sh
export SPORTRADAR_API=”<api_key_generada>”
``` 

Posicionarse en la carpeta src y correr en la terminal 

```sh
./tpe.sh <año> <categoria>
```

donde:
- año debe ser entre 2013 y 2021.
- categoria deber ser: 'sc', 'xf', 'cw', 'go', 'mc' o 'enas' (este solo funciona con 2020).

