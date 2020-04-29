// Fill out your copyright notice in the Description page of Project Settings.


#include "PaintPawn.h"

APaintPawn::APaintPawn() 
{
	
}

void APaintPawn::EnableMouse()
{
	GetWorld()->GetFirstPlayerController()->bShowMouseCursor = true;
}

void APaintPawn::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent) 
{
	Super::SetupPlayerInputComponent(InputComponent);
	InputComponent->BindAxis("Draw", this, &APaintPawn::draw);
	InputComponent->BindAxis("Remove", this, &APaintPawn::remove);
	InputComponent->BindAxis("Clear", this, &APaintPawn::clear);
}

void APaintPawn::draw(float AxisValue) 
{
	isLeftMouseDown = AxisValue == 1.0f;
}

void APaintPawn::remove(float AxisValue) 
{
	isRightMouseDown = AxisValue == 1.0f;
}

void APaintPawn::clear(float AxisValue) 
{
	if (AxisValue == 1.0f) 
	{
		//plane->clearRenderTarget();
	}
}

void APaintPawn::updateSphere() 
{
	USceneComponent* sphereObject = Cast<USceneComponent>(GetComponentByClass(UStaticMeshComponent::StaticClass()));
	sphereObject->SetWorldLocation(position);
}

void APaintPawn::findTraceUnderMouse() 
{
	FHitResult hitResult;
	bool hasHit = GetWorld()->GetFirstPlayerController()->GetHitResultUnderCursorByChannel (ETraceTypeQuery::TraceTypeQuery1, true, hitResult);
	if (hasHit) 
	{
		mouseVelocity = hitResult.Location - position;
		position = hitResult.Location;
	}
}

void APaintPawn::Tick(float DeltaTime) 
{
	findTraceUnderMouse();
	updateSphere();

	if (isLeftMouseDown) 
	{
		velocity = mouseVelocity * intensity;
		plane->createDrawBrush(position, velocity, brushSize);
	}
	else if (isRightMouseDown) 
	{
		plane->createEraseBrush(position);
	}
}