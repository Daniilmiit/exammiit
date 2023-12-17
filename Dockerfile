# Используем образ базы для сборки
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Установка рабочей директории
WORKDIR /build

# Копирование проекта и восстановление зависимостей
COPY . ./
RUN dotnet restore

# Сборка проекта в файл DLL
RUN dotnet publish -c Release -o out app.csproj

# Используем образ ASP.NET для развертывания
FROM mcr.microsoft.com/dotnet/aspnet:6.0

RUN apt update && apt install nginx -y

RUN mkdir /var/www/miitexam

# Копирование собранной DLL из предыдущего этапа
COPY --from=build /build/out /var/www/miitexam/

# Копируем конфиг Nginx
COPY ./compiled/default /etc/nginx/sites-available/
COPY ./compiled/index.html /var/www/miitexam/
RUN service nginx restart

# Открытие порта, если необходимо
EXPOSE 80

CMD nginx -t

# Запуск приложения
ENTRYPOINT ["dotnet","/var/www/miitexam/app.dll"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]