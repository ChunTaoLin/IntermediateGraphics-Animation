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

UCLASS()
class GRAPHICSFINAL_API ACanvasPlane : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ACanvasPlane();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	virtual void OnConstruction(const FTransform& Transform) override;

public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	UPROPERTY(BlueprintReadWrite, EditAnywhere) UMaterialInstanceDynamic * brush;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UMaterialInstanceDynamic * eraseBrush;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UTextureRenderTarget2D * currentRenderTarget;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UTextureRenderTarget2D * texRenderTarget;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UMaterialInterface* renderTarget;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) UMaterialInterface* renderTargetOne;

	UFUNCTION(BlueprintCallable) void createEraseBrush(const FVector& position, const float& brushSize);
	UFUNCTION(BlueprintCallable) void createDrawBrush(const FVector& position, const FVector& velocity, const float& brushSize);
	UFUNCTION(BlueprintCallable) void clearRenderTarget();
	UFUNCTION(BlueprintCallable) void makeRenderTarget();
};
