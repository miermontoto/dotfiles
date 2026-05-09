Genera un resumen de diseño/implementación de los cambios hechos en esta sesión o rama, listo para documentar en Obsidian.

## Antes de empezar

Lee `~/.claude/commands/design-summary.md` (este archivo) para asegurarte de tener las instrucciones más actualizadas. Si durante la ejecución descubres algo que mejoraría este comando para futuras ejecuciones (un patrón nuevo del usuario, una preferencia de formato, un caso que no estaba cubierto), **actualiza este archivo** al terminar con las lecciones aprendidas.

## Instrucciones

1. Analiza todos los cambios en los repos del directorio de trabajo (git diff, archivos nuevos/modificados)
2. Agrupa por capa: API, gestor, app (o las que apliquen)
3. Escribe en español, con tono natural y directo -- nada de "Se ha procedido a..." ni lenguaje corporativo
4. Usa "ccs" como shorthand para "campos custom"
5. Si algo es un poco feo o tiene deuda técnica, dilo tal cual
6. Incluye observaciones personales cuando aporten (ej. "con empresas tipo TRESA puede reventar")
7. Headers planos: `## api`, `## gestor`, `## app` -- sin nombres de repo entre paréntesis
8. Bullet lists para multi-punto, prosa para secciones simples
9. Si hay datos de prueba configurados, inclúyelos en una tabla al final
10. Referencia tickets Jira como `JIRA:OKT-XXXX`

## Estructura esperada

```
# OKT-XXXX: Título descriptivo

## Resumen
Párrafo breve de qué va el cambio y por qué.

---

## api
### Sección 1
...

## gestor
### Sección 1
...

## app
### Sección 1
...

---

## Datos de prueba configurados
Tabla con empresa, entidad, configuración usada para probar.
```

## Output

Crea una carpeta dentro del trimestre actual en `~/okt/vault/notes/` (ej. `~/okt/vault/notes/2026-Q1/OKT-18167/`). Usa la clave Jira si hay ticket. Dentro, escribe el resumen como `resumen.md`. Si no hay ticket Jira claro, pregunta al usuario cómo quiere llamar a la carpeta. El trimestre se determina por la fecha actual: Q1 = ene-mar, Q2 = abr-jun, Q3 = jul-sep, Q4 = oct-dic.

## Lecciones aprendidas

_(Este bloque se actualiza automáticamente con aprendizajes de cada ejecución)_

- **Sesiones de infra ops sin code changes**: cuando no hay git diff ni cambios de codigo, adaptar la estructura del resumen a las operaciones realizadas (agrupando por tecnologia en vez de por capa api/gestor/app). Usar headers como `## mysql`, `## mongodb` en vez de `## api`.
- **Output path**: el resumen anterior se creo en `~/okt/vault/` directamente. El path correcto es `~/okt/vault/notes/<trimestre>/<nombre>/resumen.md`. Actualizada la seccion de Output para reflejar esto.
- **Inventarios de instancias**: cuando la sesion toca muchas instancias AWS, incluir una tabla de inventario al final es util para referencia futura.
- **Cambios single-repo con refactor arquitectonico**: cuando todos los cambios caen en un solo repo pero son un refactor profundo (nueva abstraccion, nueva pila de auth, etc.), no forzar la estructura `## api / ## gestor / ## app`. Usar `## <nombre-repo>` como header unico y secciones internas por fase o capa logica (`### Abstraccion`, `### Auth stack`, `### Operaciones`). Incluir timeline de deprecacion si es relevante.
- **Working tree clean al ejecutar**: si git status sale limpio, buscar en `git log --since` los commits de la sesion. El usuario puede haber commiteado entre la sesion de trabajo y la generacion del resumen.
