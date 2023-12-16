# Используем образ базы для сборки
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Установка рабочей директории
WORKDIR /build

# Копирование проекта и восстановление зависимостей
COPY . .
RUN dotnet restore

# Сборка проекта в файл DLL
RUN dotnet publish -c Release -o out app.csproj

# Используем образ ASP.NET для развертывания
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Установка рабочей директории
WORKDIR /var/www/miitexam

# Копирование собранной DLL из предыдущего этапа
COPY --from=build-env  /build .

# Открытие порта, если необходимо
EXPOSE 80

# Запуск приложения
ENTRYPOINT ["run.sh"]