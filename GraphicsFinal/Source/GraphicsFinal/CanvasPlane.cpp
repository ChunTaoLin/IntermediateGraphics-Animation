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
	makeRenderTarget();
}

// Called every frame
void ACanvasPlane::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

void ACanvasPlane::OnConstruction(const FTransform& Transform) 
{
	brush = UMaterialInstanceDynamic::Create(renderTarget, NULL);
	eraseBrush = UMaterialInstanceDynamic::Create(renderTargetOne, NULL);
}

void ACanvasPlane::createEraseBrush(const FVector& position)
{
	UStaticMeshComponent * planeObject = Cast<UStaticMeshComponent>(GetComponentByClass(UStaticMeshComponent::StaticClass()));
	float planeLength = (planeObject->GetStaticMesh()->GetBounds().BoxExtent.X * 2.0f);
	eraseBrush->SetVectorParameterValue("Position", (UKismetMathLibrary::InverseTransformLocation(GetActorTransform(), position) / planeLength) + 0.5f);
	eraseBrush->SetScalarParameterValue("Radius", 0.5f);

	UKismetRenderingLibrary::DrawMaterialToRenderTarget(GetWorld(), texRenderTarget, eraseBrush);
	UKismetRenderingLibrary::DrawMaterialToRenderTarget(GetWorld(), currentRenderTarget, eraseBrush);
}

void ACanvasPlane::createDrawBrush(const FVector& position, const FVector& velocity, const float& brushSize) 
{
	UStaticMeshComponent* planeObject = Cast<UStaticMeshComponent>(GetComponentByClass(UStaticMeshComponent::StaticClass()));
	float planeLength = (planeObject->GetStaticMesh()->GetBounds().BoxExtent.X * 2.0f);
	brush->SetVectorParameterValue("Position", (UKismetMathLibrary::InverseTransformLocation(GetActorTransform(), position) / planeLength) + 0.5f);
	brush->SetVectorParameterValue("Velocity", velocity);
	brush->SetScalarParameterValue("Radius", brushSize);

	UKismetRenderingLibrary::DrawMaterialToRenderTarget(GetWorld(), texRenderTarget, brush);
	UKismetRenderingLibrary::DrawMaterialToRenderTarget(GetWorld(), currentRenderTarget, brush);
}

void ACanvasPlane::clearRenderTarget() 
{
	UKismetRenderingLibrary::ClearRenderTarget2D(GetWorld(),texRenderTarget);
}

void ACanvasPlane::makeRenderTarget() 
{
	currentRenderTarget = UKismetRenderingLibrary::CreateRenderTarget2D(GetWorld(), 1026, 1026);
	currentRenderTarget->LODGroup = TextureGroup::TEXTUREGROUP_RenderTarget;
	clearRenderTarget();
}