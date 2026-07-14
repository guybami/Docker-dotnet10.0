# new code 
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0@sha256:3fcf6f1e809c0553f9feb222369f58749af314af6f063f389cbd2f913b4ad556 AS build

WORKDIR /source

# Copy solution and project files
COPY aspnetapp.sln .
COPY aspnetapp/*.csproj ./aspnetapp/

# Restore dependencies
RUN dotnet restore aspnetapp.sln

# Copy source code
COPY aspnetapp/. ./aspnetapp/

# Publish application
WORKDIR /source/aspnetapp
RUN dotnet publish aspnetapp.csproj -c Release -o /app --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0@sha256:b4bea3a52a0a77317fa93c5bbdb076623f81e3e2f201078d89914da71318b5d8 AS runtime

WORKDIR /app

# Copy published files from build stage
COPY --from=build /app .

# Expose HTTP port
EXPOSE 8080

# Start application
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
