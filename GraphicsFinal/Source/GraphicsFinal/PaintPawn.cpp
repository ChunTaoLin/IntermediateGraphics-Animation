// Fill out your copyright notice in the Description page of Project Settings.


#include "PaintPawn.h"

APaintPawn::APaintPawn() 
{
	
}

void APaintPawn::BeginPlay() 
{
	Super::BeginPlay();
}

void APaintPawn::InitializePawn() 
{
	EnableMouse();
	createUIWidget();
	setPlane();
}

void APaintPawn::setPlane() 
{
	TSubclassOf<ACanvasPlane> classToFind;
	classToFind = ACanvasPlane::StaticClass();
	TArray<AActor*> foundPlanes;
	UGameplayStatics::GetAllActorsOfClass(GetWorld(), classToFind, foundPlanes);
	plane = Cast<ACanvasPlane>(foundPlanes[0]);
}

void APaintPawn::createUIWidget() 
{
	UUserWidget* Menu = CreateWidget<UUserWidget>(GetWorld()->GetFirstPlayerController(), CharacterSelectWidgetClass);
	Menu->AddToViewport();
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
}

void APaintPawn::draw(float AxisValue) 
{
	isLeftMouseDown = AxisValue == 1.0f;
}

void APaintPawn::remove(float AxisValue) 
{
	isRightMouseDown = AxisValue == 1.0f;
}

void APaintPawn::clear() 
{
	plane->clearRenderTarget();
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
		plane->createEraseBrush(position, brushSize);
	}
}