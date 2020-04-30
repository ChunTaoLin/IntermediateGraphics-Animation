// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "Materials/MaterialInstanceDynamic.h"
#include "Kismet/KismetMathLibrary.h"
#include "Kismet/KismetRenderingLibrary.h"
#include "Engine/TextureRenderTarget2D.h"
#include "Materials/MaterialInterface.h"
#include "Components/StaticMeshComponent.h"
#include "CanvasPlane.generated.h"

// Constants
const int SIZE_OF_RENDER_TARGET = 1026;
const float BRUSH_POSITION_OFFSET = 0.5f;

UCLASS()
class GRAPHICSFINAL_API ACanvasPlane : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ACanvasPlane();

protected:
	// Built-in functions
	virtual void BeginPlay() override;
	virtual void OnConstruction(const FTransform& Transform) override;
	virtual void Tick(float DeltaTime) override;

private:
	// Local functions
	void MakeRenderTarget();

public:	
	// Material instances
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UMaterialInstanceDynamic* brush;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UMaterialInstanceDynamic* eraseBrush;
	
	// Render Targets
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UTextureRenderTarget2D * currentRenderTarget;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UTextureRenderTarget2D * texRenderTarget;
	
	// Material Interfaces
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UMaterialInterface* renderTarget;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UMaterialInterface* renderTargetOne;

	// Functions
	UFUNCTION(BlueprintCallable) void CreateEraseBrush(const FVector& position, const float& brushSize);
	UFUNCTION(BlueprintCallable) void CreateDrawBrush(const FVector& position, const FVector& velocity, const float& brushSize);
	UFUNCTION(BlueprintCallable) void ClearRenderTarget();
};
