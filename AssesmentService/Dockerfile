FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /src
COPY ["AssesmentService/AssesmentService.csproj", "AssesmentService/"]
RUN dotnet restore "AssesmentService/AssesmentService.csproj"
COPY . .
WORKDIR "/src/AssesmentService"
RUN dotnet build "AssesmentService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AssesmentService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AssesmentService.dll"]