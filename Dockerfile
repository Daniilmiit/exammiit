FROM mcr.microsoft.com/dotnet/sdk:6.0

WORKDIR /app
COPY ./app .

RUN dotnet restore
RUN dotnet build --no-restore -c Release
CMD dotnet run --no-build --urls=http://0.0.0.0:5000