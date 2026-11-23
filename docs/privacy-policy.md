# Privacy Policy

Last updated: November 22, 2026

This page is the privacy policy for MineSweeper, Android application id `com.h4j4x.minesweeper`. It applies only to that app, and it describes the build currently on Google Play.

You can play without signing in. Signing in is optional in settings, and it is requested if you choose to submit a finished game.

## Data on the device

The app stores these settings in `shared_preferences` on the device. They are not uploaded:

- board rows, columns, and mine count
- theme mode and color scheme
- whether a tap explores adjacent cells

## Sign-in and scores

Sign-in uses Google Sign-In and Firebase Authentication. The app sends a Google ID token to Firebase. After sign-in it can show the Firebase user's display name and email in settings. The email is not written to the score records.

If you submit a score, Cloud Firestore stores:

- Firebase user id
- Google display name, or "-" if none is available
- elapsed seconds
- the time of the score
- the board key, such as rows, columns, and mine count

The ten best times for a board are readable by the app and shown to other players, with the display name and time. Your own saved times are stored under your Firebase user id.

This version does not submit scores to Google Play Games. The release manifest still contains a Play Games app id. It is not used to send player data.

## Crash reports

Firebase Crashlytics receives fatal Flutter errors, and errors from Google sign-in, including the error and stack trace. Google Analytics is not included in the app and is not enabled for this Firebase project. The app does not show advertising.

## Permissions

The release manifest requests `INTERNET`, which the app uses for Firebase. It does not request health permissions, and the app does not read Health Connect data.

## Who receives data

Google receives the sign-in, the Firestore records, and the Crashlytics reports, as the operator of those Firebase services. Other players can see a display name and time that is on a board's top-ten list. We do not sell the data and we do not share it with advertising networks.

## Deletion

Signing out ends the session on the device. This version cannot delete the Firebase account or the scores stored in Cloud Firestore.

## Changes

The current text is this page. The date above changes when the page changes.

## Contact

Questions about this policy: [matt@sp1ke.dev](mailto:matt@sp1ke.dev).

# Política de privacidad

Actualizado: 22 de noviembre de 2026

Esta página es la política de privacidad de MineSweeper, id de aplicación Android `com.h4j4x.minesweeper`. Se aplica solo a esa app y describe la versión que está ahora en Google Play.

Se puede jugar sin iniciar sesión. El inicio de sesión es opcional en ajustes, y se pide si eliges enviar una partida terminada.

## Datos en el dispositivo

La app guarda estos ajustes en `shared_preferences` en el dispositivo. No se suben:

- filas, columnas y número de minas del tablero
- tema y esquema de color
- si un toque explora las casillas vecinas

## Inicio de sesión y puntuaciones

El inicio de sesión usa Google Sign-In y Firebase Authentication. La app envía un token de identidad de Google a Firebase. Después puede mostrar en ajustes el nombre y el email del usuario de Firebase. El email no se escribe en los registros de puntuación.

Si envías una puntuación, Cloud Firestore guarda:

- id de usuario de Firebase
- nombre visible de Google, o "-" si no hay
- segundos transcurridos
- la hora de la puntuación
- la clave del tablero: filas, columnas y número de minas

Los diez mejores tiempos de un tablero los lee la app y se muestran a otros jugadores, con el nombre y el tiempo. Tus tiempos guardados quedan bajo tu id de Firebase.

Esta versión no envía puntuaciones a Google Play Games. El manifiesto de release aún contiene un id de Play Games. No se usa para enviar datos del jugador.

## Informes de fallos

Firebase Crashlytics recibe los errores fatales de Flutter y los errores del inicio de sesión con Google, incluido el error y la traza. Google Analytics no está en la app y no está activado en este proyecto de Firebase. La app no muestra publicidad.

## Permisos

El manifiesto de release pide `INTERNET`, que la app usa para Firebase. No pide permisos de salud, y la app no lee datos de Health Connect.

## Quién recibe los datos

Google recibe el inicio de sesión, los registros de Firestore y los informes de Crashlytics, como operador de esos servicios de Firebase. Otros jugadores pueden ver un nombre y un tiempo que estén en la lista de los diez mejores de un tablero. No vendemos los datos ni los compartimos con redes publicitarias.

## Eliminación

Cerrar sesión termina la sesión en el dispositivo. Esta versión no puede borrar la cuenta de Firebase ni las puntuaciones guardadas en Cloud Firestore.

## Cambios

El texto vigente es esta página. La fecha de arriba cambia cuando cambia la página.

## Contacto

Preguntas sobre esta política: [matt@sp1ke.dev](mailto:matt@sp1ke.dev).
