// Copyright 1998-2019 Epic Games, Inc. All Rights Reserved.
/*===========================================================================
	Generated code exported from UnrealHeaderTool.
	DO NOT modify this manually! Edit the corresponding .h files instead!
===========================================================================*/

#include "UObject/GeneratedCppIncludes.h"
#include "GraphicsFinal/GraphicsFinalGameModeBase.h"
#ifdef _MSC_VER
#pragma warning (push)
#pragma warning (disable : 4883)
#endif
PRAGMA_DISABLE_DEPRECATION_WARNINGS
void EmptyLinkFunctionForGeneratedCodeGraphicsFinalGameModeBase() {}
// Cross Module References
	GRAPHICSFINAL_API UClass* Z_Construct_UClass_AGraphicsFinalGameModeBase_NoRegister();
	GRAPHICSFINAL_API UClass* Z_Construct_UClass_AGraphicsFinalGameModeBase();
	ENGINE_API UClass* Z_Construct_UClass_AGameModeBase();
	UPackage* Z_Construct_UPackage__Script_GraphicsFinal();
// End Cross Module References
	void AGraphicsFinalGameModeBase::StaticRegisterNativesAGraphicsFinalGameModeBase()
	{
	}
	UClass* Z_Construct_UClass_AGraphicsFinalGameModeBase_NoRegister()
	{
		return AGraphicsFinalGameModeBase::StaticClass();
	}
	struct Z_Construct_UClass_AGraphicsFinalGameModeBase_Statics
	{
		static UObject* (*const DependentSingletons[])();
#if WITH_METADATA
		static const UE4CodeGen_Private::FMetaDataPairParam Class_MetaDataParams[];
#endif
		static const FCppClassTypeInfoStatic StaticCppClassTypeInfo;
		static const UE4CodeGen_Private::FClassParams ClassParams;
	};
	UObject* (*const Z_Construct_UClass_AGraphicsFinalGameModeBase_Statics::DependentSingletons[])() = {
		(UObject* (*)())Z_Construct_UClass_AGameModeBase,
		(UObject* (*)())Z_Construct_UPackage__Script_GraphicsFinal,
	};
#if WITH_METADATA
	const UE4CodeGen_Private::FMetaDataPairParam Z_Construct_UClass_AGraphicsFinalGameModeBase_Statics::Class_MetaDataParams[] = {
		{ "Comment", "/**\n * \n */" },
		{ "HideCategories", "Info Rendering MovementReplication Replication Actor Input Movement Collision Rendering Utilities|Transformation" },
		{ "IncludePath", "GraphicsFinalGameModeBase.h" },
		{ "ModuleRelativePath", "GraphicsFinalGameModeBase.h" },
		{ "ShowCategories", "Input|MouseInput Input|TouchInput" },
	};
#endif
	const FCppClassTypeInfoStatic Z_Construct_UClass_AGraphicsFinalGameModeBase_Statics::StaticCppClassTypeInfo = {
		TCppClassTypeTraits<AGraphicsFinalGameModeBase>::IsAbstract,
	};
	const UE4CodeGen_Private::FClassParams Z_Construct_UClass_AGraphicsFinalGameModeBase_Statics::ClassParams = {
		&AGraphicsFinalGameModeBase::StaticClass,
		nullptr,
		&StaticCppClassTypeInfo,
		DependentSingletons,
		nullptr,
		nullptr,
		nullptr,
		ARRAY_COUNT(DependentSingletons),
		0,
		0,
		0,
		0x009002A8u,
		METADATA_PARAMS(Z_Construct_UClass_AGraphicsFinalGameModeBase_Statics::Class_MetaDataParams, ARRAY_COUNT(Z_Construct_UClass_AGraphicsFinalGameModeBase_Statics::Class_MetaDataParams))
	};
	UClass* Z_Construct_UClass_AGraphicsFinalGameModeBase()
	{
		static UClass* OuterClass = nullptr;
		if (!OuterClass)
		{
			UE4CodeGen_Private::ConstructUClass(OuterClass, Z_Construct_UClass_AGraphicsFinalGameModeBase_Statics::ClassParams);
		}
		return OuterClass;
	}
	IMPLEMENT_CLASS(AGraphicsFinalGameModeBase, 492644874);
	template<> GRAPHICSFINAL_API UClass* StaticClass<AGraphicsFinalGameModeBase>()
	{
		return AGraphicsFinalGameModeBase::StaticClass();
	}
	static FCompiledInDefer Z_CompiledInDefer_UClass_AGraphicsFinalGameModeBase(Z_Construct_UClass_AGraphicsFinalGameModeBase, &AGraphicsFinalGameModeBase::StaticClass, TEXT("/Script/GraphicsFinal"), TEXT("AGraphicsFinalGameModeBase"), false, nullptr, nullptr, nullptr);
	DEFINE_VTABLE_PTR_HELPER_CTOR(AGraphicsFinalGameModeBase);
PRAGMA_ENABLE_DEPRECATION_WARNINGS
#ifdef _MSC_VER
#pragma warning (pop)
#endif
