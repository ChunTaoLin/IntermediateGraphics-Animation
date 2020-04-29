// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/SpectatorPawn.h"
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

	UPROPERTY(BlueprintReadWrite, EditAnywhere) bool isLeftMouseDown;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) bool isRightMouseDown;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) FVector position;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) FVector mouseVelocity;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) FVector velocity;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) float intensity;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) float brushSize;
	UPROPERTY(BlueprintReadWrite, EditAnywhere) ACanvasPlane* plane;

	void SetupPlayerInputComponent(UInputComponent* PlayerInputComponent);
	void draw(float AxisValue);
	void remove(float AxisValue);
	void clear(float AxisValue);
	UFUNCTION(BlueprintCallable) void EnableMouse();
	UFUNCTION(BlueprintCallable) void updateSphere();
	UFUNCTION(BlueprintCallable) void findTraceUnderMouse();
};
