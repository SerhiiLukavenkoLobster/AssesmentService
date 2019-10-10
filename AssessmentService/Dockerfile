FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /src
COPY ["AssessmentService/AssessmentService.csproj", "AssessmentService/"]
RUN dotnet restore "AssessmentService/AssessmentService.csproj"
COPY . .
WORKDIR "/src/AssessmentService"
RUN dotnet build "AssessmentService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AssessmentService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AssessmentService.dll"]