FROM mcr.microsoft.com/dotnet/framework/sdk:4.8

WORKDIR /app
COPY . .

# Restaurar pacotes NuGet
RUN nuget restore AAEmu-Launcher.sln

# Compilar em modo Release
RUN msbuild AAEmu-Launcher.sln /p:Configuration=Release /p:Platform="Any CPU"

# O executável estará em AAEmu.Launcher/bin/Release/
CMD ["ls", "-la", "AAEmu.Launcher/bin/Release/"]