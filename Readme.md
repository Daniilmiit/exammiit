# Проект для экзамена, МИИТ, Пономарёв Д.К.
## Описание
Приложение dotnet, работающее на порту 5000

Ngnix в качестве reverse proxy с порта 80 на порт 5000 для доступа к приложению.

index.html - простая форма на bootstrap для создания POST запроса к приложению и кнопка запуска healthcheck

Приложение состоит из трёх конроллеров - контроллер Car, контрллер Driver и контроллер Healthcheck.

controllers.cs - файл контроллеров. 

Car принимает POST-запрос, содержащий Производителя и Модель машины, обрабатывает его, сохраняя данные в сессию, и выдает данные с помощью GET-запроса на экран.

Driver принимает POST-запрос, содержащий Имя и Возраст  водителя, обрабатывает его, сохраняя данные в сессию, и выдает данные с помощью GET-запроса на экран.

Healthcheck проверяет доступность контроллера Car по API (http://localhost:5000/api/Car) и выдает сообщение об успехе, если все работает корректно.

app.csproj - описание проекта приложения

Program.cs - описание приложения для сборки

startup.cs - описание процесса старта прилоежния, используемых контролеров и функционала сессий для сохранения введенных в форму данных.

## Запуск собранного приложения
### Для Ubuntu
```bash
git clone git@github.com:Daniilmiit/exammiit.git
cd exammiit
cd compiled/
chmod +x run.sh
./run.sh
# Ввести пароль sudo
```

## Сборка и запуск приложения
### Для Ubuntu
```bash
git clone git@github.com:Daniilmiit/exammiit.git
cd exammiit
sudo -i
# Ввести пароль root
chmod +x run.sh
./run.sh
```
## Запуск в Docker на любой системе
Установить Docker Desktop или Docker из репозитория дистрибутива для Linux
Установить docker compose
```bash
git clone git@github.com:Daniilmiit/exammiit.git
cd exammiit
docker-compose -up --build
```
Контейнер Docker соберет и запустит приложение, выдаст порт 80 будет проброшен на ломальную машину.