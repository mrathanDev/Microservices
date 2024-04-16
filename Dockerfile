# Use the official .NET Core SDK image with .NET 8.0
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project files and restore dependencies
COPY *.sln ./
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . .

# Build the application
RUN dotnet publish -c Release -o out

# Use the official .NET Core Runtime image with .NET 8.0 as the final base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the published application files from the build stage to the final image
COPY --from=build /app/out ./

# Expose the port the application listens on
EXPOSE 80

# Define the entry point for the container
ENTRYPOINT ["dotnet", "Microservices.dll"]