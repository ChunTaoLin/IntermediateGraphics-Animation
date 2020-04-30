// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/SpectatorPawn.h"
#include "Blueprint/UserWidget.h"
#include "Kismet/GameplayStatics.h"
#include "CanvasPlane.h"
#include "PaintPawn.generated.h"

/**
 * 
 */
UCLASS()
class GRAPHICSFINAL_API APaintPawn : public ASpectatorPawn
{
	GENERATED_BODY()
	APaintPawn();

public:

	virtual void Tick(float DeltaTime) override;
	virtual void BeginPlay() override;

	// Booleans
	UPROPERTY(BlueprintReadWrite, EditAnywhere) bool isLeftMouseDown;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) bool isRightMouseDown;
	
	// Vectors
	UPROPERTY(BlueprintReadWrite, EditAnywhere) FVector position;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) FVector mouseVelocity;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) FVector velocity;
	
	// Floats
	UPROPERTY(BlueprintReadWrite, EditAnywhere) float intensity;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) float brushSize;
	
	// Classes
	UPROPERTY(BlueprintReadWrite, EditAnywhere) ACanvasPlane* plane;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) TSubclassOf<UUserWidget> CharacterSelectWidgetClass;

	void SetupPlayerInputComponent(UInputComponent* PlayerInputComponent);
	void draw(float AxisValue);
	void remove(float AxisValue);
	UFUNCTION(BlueprintCallable) void clear();
	UFUNCTION(BlueprintCallable) void InitializePawn();
	UFUNCTION(BlueprintCallable) void EnableMouse();
	UFUNCTION(BlueprintCallable) void updateSphere();
	UFUNCTION(BlueprintCallable) void setPlane();
	UFUNCTION(BlueprintCallable) void createUIWidget();
	UFUNCTION(BlueprintCallable) void findTraceUnderMouse();
};
