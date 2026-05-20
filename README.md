# Sábana Digital de Enfermería - HUDN

## Descripción del proyecto

Esta aplicación móvil y web fue desarrollada para la Unidad de Cuidados Intensivos del Hospital Universitario Departamental de Nariño. Su función principal es reemplazar la sábana clínica física de papel que utiliza el personal de enfermería para el registro diario de pacientes críticos.

La app permite registrar, consultar y exportar todos los datos clínicos de los pacientes en tiempo real, eliminando errores de transcripción y reduciendo el tiempo que el personal de enfermería dedica al llenado manual de formatos.

## Tecnologías utilizadas

- Flutter y Dart para el desarrollo de la interfaz y la lógica de negocio
- Firebase Firestore como base de datos en la nube
- Firebase Authentication para el control de acceso por roles
- Riverpod para la gestión del estado de la aplicación
- Freezed para la serialización de modelos de datos
- Librerías pdf y printing para la generación de reportes

## Funcionalidades principales

La aplicación cuenta con los siguientes módulos completamente implementados:

Registro de pacientes: permite crear, editar y gestionar los ingresos de pacientes a la UCI con sus datos personales, diagnósticos y asignación de cama.

Monitoría hemodinámica: registro por hora de signos vitales y parámetros como presión arterial, frecuencia cardíaca, frecuencia respiratoria, temperatura, presión venosa central, gasto cardíaco, resistencias vasculares y saturación de oxígeno. El horario cubre desde las 8 de la mañana hasta las 7 de la mañana del día siguiente.

Balance de líquidos: registro de líquidos administrados y eliminados por hora. Incluye campos para diuresis, pérdidas insensibles, sondas, drenajes, deposiciones y diálisis. El balance se calcula automáticamente.

Nutrición: registro antropométrico con cálculo automático de índice de masa corporal y requerimiento calórico. Permite registrar la nutrición administrada por turno con distribución de proteínas, lípidos y carbohidratos.

Escala de Glasgow: evaluación neurológica con registro de apertura ocular, respuesta verbal y respuesta motora. El puntaje total se calcula automáticamente.

Control de sedación: escala RASS con valores desde menos 5 hasta mas 4 para registrar el nivel de sedación del paciente por hora.

Control de cambio de posición: registro de posiciones del paciente por hora para prevenir úlceras por presión.

Catéteres y marcapasos: gestión completa de dispositivos médicos con fecha de inserción, tipo, vía, frecuencia y características del sitio.

Sondas y drenes: registro de sondas con fecha de inserción, días en uso y región anatómica.

Procedimientos especiales: registro de procedimientos con estados de seguimiento que permiten marcar cuando están por realizar, realizados o reportados. Incluye sección para medicamentos en infusión.

Antibióticos: gestión de tratamientos antibióticos con secciones separadas para manitol y corticoides. Permite marcar los días de administración.

Control de riesgos: evaluación de úlceras por presión con escala Braden, riesgo de caídas con escala Downton, anticoagulación, alergias y aislamiento.

Observaciones extras: tablas para registrar solicitudes de laboratorio, resultados de cultivos, órdenes de transfusión sanguínea y firmas digitales del personal de enfermería por turno.

Reporte PDF: generación de un documento completo con todos los datos del paciente siguiendo el formato tradicional de la sábana física. El PDF se puede guardar, compartir o imprimir desde el dispositivo.

## Roles de usuario

La aplicación maneja cinco roles con diferentes niveles de acceso:

Administrador: acceso total a todas las funciones incluyendo eliminación o edicion de registros y gestion.

Enfermero jefe: acceso completo a lectura, escritura y edición de todos los módulos.

Auxiliar de enfermería: puede registrar datos en los módulos asignados.

Médico: visualización completa de todos los datos con capacidad de realizar anotaciones.

Nutricionista: acceso al módulo de nutrición y demás registros complementarios.

## Estructura del proyecto

El código está organizado siguiendo Clean Architecture con cuatro capas bien diferenciadas. Cada funcionalidad principal tiene su propio módulo dentro de la carpeta features, lo que facilita el mantenimiento y la expansión futura.

La capa de dominio contiene los modelos de datos definidos con Freezed. La capa de datos implementa los repositorios que se comunican con Firebase Firestore. La capa de presentación incluye las pantallas y los controladores. La capa de aplicación contiene servicios como el generador de reportes PDF.

## Instalación y configuración

Para ejecutar el proyecto en un entorno de desarrollo se necesita tener instalado Flutter SDK y una cuenta de Firebase. Los pasos son clonar el repositorio, ejecutar flutter pub get para instalar las dependencias, configurar el proyecto de Firebase con flutterfire configure y finalmente ejecutar flutter run.

Para generar una versión de producción para Android se utiliza el comando flutter build apk --release. Para la versión web se usa flutter build web y luego firebase deploy --only hosting.

## Estado del proyecto

La aplicación se encuentra completamente funcional con todos los módulos implementados y validados con el personal de la UCI del Hospital Universitario Departamental de Nariño. Se completaron mas de 4500 líneas de código, 10 pantallas principales, 18 módulos funcionales y se documentaron manuales de usuario y guía técnica para desarrolladores.

## Contacto

Desarrollado por Esneyder Jesús Ibarra Rosero como parte de la práctica profesional en ingeniería de sistemas. Para soporte o consultas técnicas contactar al correo institucional o al área de sistemas del hospital.

Primer desarrollador Carlos Botina Universidad Mariana
Segundo desarrollador Jhon Tajumbina universidad Mariana
