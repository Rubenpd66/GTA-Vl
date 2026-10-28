# Ciudad Libre — prototipo Roblox

Creado directamente en Place1 de Roblox Studio. Guarda el lugar desde Archivo > Guardar en archivo para conservar el proyecto .rbxl. No se ha publicado.

## Controles

- WASD: caminar o conducir.
- Shift: correr. Espacio: saltar o salir del coche.
- E: interactuar (mantener brevemente en actividades).
- R o botón Recuperar: volver al garaje y cancelar la actividad.

Tres actividades junto al garaje: paquete ($100), conducción ($150), carrera de cinco controles en 100 segundos ($250). La prueba policial aumenta la alerta hasta 3; alejarse más de 95 unidades durante 10 segundos la elimina.

## Código

- build-city.luau: generador del escenario, ejecutar una vez en edición sobre una base vacía.
- city-server.server.luau: Script en ServerScriptService (CiudadServer).
- city-client.client.luau: LocalScript en StarterPlayer/StarterPlayerScripts (CiudadClient).

## Verificación

Probados en Play: HUD, conducción mediante W, entrega y recompensa de $100, destino de conducción y $150, secuencia de controles de carrera y $250, activación policial y movimiento de patrulla. Para verificar objetivos se usaron teletransportes de prueba; no se recorrió toda la carrera manualmente. Consola sin errores durante estas comprobaciones.

## Límites

Vehículos cinemáticos de velocidad constante con colisiones básicas. Patrulla de persecución directa sin navegación de obstáculos. Sin guardado de dinero, tráfico, armas ni publicación. Pensado para pruebas de un jugador con teclado.
