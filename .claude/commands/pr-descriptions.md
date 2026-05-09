Genera descripciones de PR para cada capa/repo afectado por los cambios de esta sesión o rama.

## Antes de empezar

Lee `~/.claude/commands/pr-descriptions.md` (este archivo) para asegurarte de tener las instrucciones más actualizadas. Si durante la ejecución descubres algo que mejoraría este comando para futuras ejecuciones (un patrón nuevo del usuario, una preferencia de formato, un caso que no estaba cubierto), **actualiza este archivo** al terminar con las lecciones aprendidas.

## Instrucciones

1. Analiza los cambios en todos los repos del directorio de trabajo
2. Genera una PR por cada repo que tenga cambios
3. Escribe en español, tono directo y natural
4. Usa "ccs" como shorthand para "campos custom"
5. Si algo es un workaround o tiene deuda técnica, menciónalo honestamente
6. Las pruebas deben ser concretas y accionables, no genéricas
7. En configuraciones, lista migraciones, seeders, variables de entorno. Si no hay, pon "Ninguna."

## Esquema por PR

```
# PR: nombre-del-repo

## Descripción

¿De qué va esta PR?

(Párrafo inicial resumiendo el cambio. Después, bloques con negrita para cada área si hay varias.)

**Área 1:**
- Detalle
- Detalle

**Área 2:**
- Detalle

## Pruebas

- [ ] Paso concreto de prueba 1
- [ ] Paso concreto de prueba 2
- [ ] Caso de regresión

## Configuraciones

- Migración: `nombre_de_migracion.php` -- qué hace
- Variable: `NOMBRE_VAR` -- para qué sirve

(o "Ninguna." si no aplica)
```

## Output

Usa la misma carpeta que `/design-summary` si ya existe (ej. `~/okt/vault/notes/2026-Q1/OKT-18167/`). Escribe las PRs como `prs.md` dentro de esa carpeta. Si no existe carpeta previa, créala dentro del trimestre actual en `~/okt/vault/notes/` con la clave Jira (ej. `~/okt/vault/notes/2026-Q1/OKT-18167/`) o pregunta al usuario si no hay ticket. El trimestre se determina por la fecha actual: Q1 = ene-mar, Q2 = abr-jun, Q3 = jul-sep, Q4 = oct-dic.

## Lecciones aprendidas

_(Este bloque se actualiza automáticamente con aprendizajes de cada ejecución)_

### 2026-05-06 — OKT-18508 (actualización de iconos en 4 repos)

- **Trabajos multi-repo coordinados:** cuando una sola tarea Jira toca varios repos a la vez, añade un párrafo introductorio al principio del `prs.md` que resuma el cambio global y cualquier dependencia de orden de merge entre PRs (ej. "estas 4 PRs son independientes pero la subida al CDN espera a que todas estén mergeadas"). Evita repetir contexto en cada PR.
- **Pasos post-merge:** si hay acciones que NO van en ninguna PR pero que el usuario tiene que ejecutar después (subir a S3, invalidar CDN, lanzar deploy), inclúyelas como blockquote `>` al final de la PR relevante o como sección "Orden recomendado" al final del `prs.md`. No las pongas en "Pruebas" ni en "Configuraciones" porque no son ninguna de esas dos cosas.
- **Deuda técnica que NO arreglas en la PR:** si encuentras algo roto adyacente al cambio pero decides no tocarlo (por scope, por decisión del usuario, por riesgo), menciónalo explícitamente con la frase "decisión consciente" o "no toco aquí" y la razón. Mejor que omitirlo: el reviewer entiende que lo viste y por qué lo dejaste.
- **Pruebas concretas con números:** cuando el cambio es mecánico (replace masivo, regeneración de assets), las pruebas más útiles son comandos `grep -c` o `wc -l` con el número esperado, no instrucciones genéricas tipo "verificar que se aplica el cambio". Le da al reviewer un check inmediato.
- **Repos con setup peculiar:** si un repo tiene un detalle que el reviewer puede no recordar (versión de node específica, hook que necesita node_modules, plataforma que se regenera sola), menciónalo en una nota al final de la PR de ese repo, no en la descripción principal.
- **Branch name visible en cada PR:** poner `Branch: <nombre> → <base>` justo bajo el título ayuda al reviewer a abrir la PR correcta sin volver a la lista del Jira.
