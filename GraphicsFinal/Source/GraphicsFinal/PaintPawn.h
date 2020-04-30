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

protected:
	// Built-in functions
	virtual void Tick(float DeltaTime) override;
	virtual void BeginPlay() override;
	void SetupPlayerInputComponent(UInputComponent* PlayerInputComponent);

private:
	// Local Functions
	void Draw(float AxisValue);
	void Remove(float AxisValue);

public:
	// Booleans
	UPROPERTY() bool isLeftMouseDown;
	UPROPERTY() bool isRightMouseDown;
	
	// Vectors
	UPROPERTY() FVector position;
	UPROPERTY() FVector mouseVelocity;
	UPROPERTY() FVector velocity;
	
	// Floats
	UPROPERTY(BlueprintReadWrite, EditAnywhere) float intensity;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) float brushSize;
	
	// Classes
	UPROPERTY(BlueprintReadWrite, EditAnywhere) ACanvasPlane* plane;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) TSubclassOf<UUserWidget> CharacterSelectWidgetClass;

	// Functions
	UFUNCTION(BlueprintCallable) void Clear();
	UFUNCTION(BlueprintCallable) void InitializePawn();
	UFUNCTION(BlueprintCallable) void EnableMouse();
	UFUNCTION(BlueprintCallable) void UpdateSphere();
	UFUNCTION(BlueprintCallable) void SetPlane();
	UFUNCTION(BlueprintCallable) void CreateUIWidget();
	UFUNCTION(BlueprintCallable) void FindTraceUnderMouse();
};
