// Fill out your copyright notice in the Description page of Project Settings.


#include "PaintPawn.h"

APaintPawn::APaintPawn() 
{
	
}



// Executes when created
void APaintPawn::BeginPlay() 
{
	Super::BeginPlay();
}



// The following function initializes the paint pawn values
void APaintPawn::InitializePawn() 
{
	EnableMouse();
	CreateUIWidget();
	SetPlane();
}



// Executes when player pawn is created
void APaintPawn::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(InputComponent);

	// Initialize Axes for input
	InputComponent->BindAxis("Draw", this, &APaintPawn::Draw);
	InputComponent->BindAxis("Remove", this, &APaintPawn::Remove);
}



// Executes on every tick
void APaintPawn::Tick(float DeltaTime)
{
	FindTraceUnderMouse();
	UpdateSphere();

	if (isLeftMouseDown)
	{
		// Get velocity and draw
		velocity = mouseVelocity * intensity;
		plane->CreateDrawBrush(position, velocity, brushSize);
	}
	else if (isRightMouseDown)
	{
		// Erase
		plane->CreateEraseBrush(position, brushSize);
	}
}



// The following function finds and sets the canvas plane
void APaintPawn::SetPlane() 
{
	TSubclassOf<ACanvasPlane> classToFind;
	classToFind = ACanvasPlane::StaticClass();
	TArray<AActor*> foundPlanes;
	UGameplayStatics::GetAllActorsOfClass(GetWorld(), classToFind, foundPlanes);
	plane = Cast<ACanvasPlane>(foundPlanes[0]);
}



// The following function creates the Tool UI Widget and adds it to viewport
void APaintPawn::CreateUIWidget() 
{
	UUserWidget* Menu = CreateWidget<UUserWidget>(GetWorld()->GetFirstPlayerController(), CharacterSelectWidgetClass);
	Menu->AddToViewport();
}



// The following function enables the mouse cursor
void APaintPawn::EnableMouse()
{
	GetWorld()->GetFirstPlayerController()->bShowMouseCursor = true;
}



// The following function checks if the left mouse is down to draw
void APaintPawn::Draw(float AxisValue) 
{
	isLeftMouseDown = AxisValue == 1.0f;
}



// The following function checks if the left mouse is down to erase
void APaintPawn::Remove(float AxisValue) 
{
	isRightMouseDown = AxisValue == 1.0f;
}



// The following function clears the render target attached to the canas plane
void APaintPawn::Clear() 
{
	plane->ClearRenderTarget();
}



// The following function updated the sphere to show where the brush is
void APaintPawn::UpdateSphere() 
{
	USceneComponent* sphereObject = Cast<USceneComponent>(GetComponentByClass(UStaticMeshComponent::StaticClass()));
	sphereObject->SetWorldLocation(position);
}



// The following function finds where the mouse is hovering on in world space
void APaintPawn::FindTraceUnderMouse() 
{
	// Find if mouse hits
	FHitResult hitResult;
	bool hasHit = GetWorld()->GetFirstPlayerController()->GetHitResultUnderCursorByChannel (ETraceTypeQuery::TraceTypeQuery1, true, hitResult);
	if (hasHit) 
	{
		// If it does, then get the velocity of the mouse and the new position
		mouseVelocity = hitResult.Location - position;
		position = hitResult.Location;
	}
}