// Fill out your copyright notice in the Description page of Project Settings.


#include "CanvasPlane.h"

// Sets default values
ACanvasPlane::ACanvasPlane()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

}



// Called when the game starts or when spawned
void ACanvasPlane::BeginPlay()
{
	MakeRenderTarget();
}



// Called every frame
void ACanvasPlane::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}



// Called when constructing actor
void ACanvasPlane::OnConstruction(const FTransform& Transform) 
{
	// Initialize brushes
	brush = UMaterialInstanceDynamic::Create(renderTarget, NULL);
	eraseBrush = UMaterialInstanceDynamic::Create(renderTargetOne, NULL);
}



// The following function creates an erase brush with a given position and brush size
void ACanvasPlane::CreateEraseBrush(const FVector& position, const float& brushSize)
{
	// Find plane static mesh component and get its length
	UStaticMeshComponent * planeObject = Cast<UStaticMeshComponent>(GetComponentByClass(UStaticMeshComponent::StaticClass()));
	float planeLength = (planeObject->GetStaticMesh()->GetBounds().BoxExtent.X * 2.0f);
	
	// Set up variables for position and size of erase brush
	eraseBrush->SetVectorParameterValue("Position", (UKismetMathLibrary::InverseTransformLocation(GetActorTransform(), position) / planeLength) + BRUSH_POSITION_OFFSET);
	eraseBrush->SetScalarParameterValue("Radius", brushSize);

	// Draw to erase brush render target
	UKismetRenderingLibrary::DrawMaterialToRenderTarget(GetWorld(), texRenderTarget, eraseBrush);
	UKismetRenderingLibrary::DrawMaterialToRenderTarget(GetWorld(), currentRenderTarget, eraseBrush);
}



// The following function create an create brush with a given position, velocity, and brush size
void ACanvasPlane::CreateDrawBrush(const FVector& position, const FVector& velocity, const float& brushSize) 
{
	// Find plane static mesh component and get its length
	UStaticMeshComponent* planeObject = Cast<UStaticMeshComponent>(GetComponentByClass(UStaticMeshComponent::StaticClass()));
	float planeLength = (planeObject->GetStaticMesh()->GetBounds().BoxExtent.X * 2.0f);

	// Set up variables for position and size of erase brush
	brush->SetVectorParameterValue("Position", (UKismetMathLibrary::InverseTransformLocation(GetActorTransform(), position) / planeLength) + BRUSH_POSITION_OFFSET);
	brush->SetVectorParameterValue("Velocity", velocity);
	brush->SetScalarParameterValue("Radius", brushSize);

	// Draw to erase brush render target
	UKismetRenderingLibrary::DrawMaterialToRenderTarget(GetWorld(), texRenderTarget, brush);
	UKismetRenderingLibrary::DrawMaterialToRenderTarget(GetWorld(), currentRenderTarget, brush);
}



// The following function clears the drawing render target
void ACanvasPlane::ClearRenderTarget() 
{
	UKismetRenderingLibrary::ClearRenderTarget2D(GetWorld(),texRenderTarget);
}



// The following function creates a render target with a given size
void ACanvasPlane::MakeRenderTarget() 
{
	currentRenderTarget = UKismetRenderingLibrary::CreateRenderTarget2D(GetWorld(), SIZE_OF_RENDER_TARGET, SIZE_OF_RENDER_TARGET);
	currentRenderTarget->LODGroup = TextureGroup::TEXTUREGROUP_RenderTarget;
	ClearRenderTarget();
}