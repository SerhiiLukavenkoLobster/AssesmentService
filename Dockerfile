FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build-env
WORKDIR /app
COPY AssesmentService/*.csproj ./
RUN dotnet restore
COPY AssesmentService/ ./
RUN dotnet publish -c Release -o output
# Runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.0
WORKDIR /app
COPY --from=build-env /app/output .
ENTRYPOINT ["dotnet", "AssesmentService.dll"]