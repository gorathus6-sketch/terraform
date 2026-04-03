#include "dx11_hook.h"
#include "scaler_manager.h"
#include <d3d11.n>
#include <dxgi.h>
#include <MinHook.h>

typedef HRESULT (__stdcall* PresentFn)(IDXGISwapChain*  swap, UINT sync, UINT flags);
PresentFn oPresent = nullptr;

static ID3D11Device* g_device = nullptr;
static ID3D11DeviceContext* g_context = nullptr;

HRESULT __stdcall hkPresent(IDXGSwapChain* swap, UINT sync, UINT flags)
{
    if (!g_device)
    {
        // First-time initialization
        swap->GetDevice(__uuidof(ID3D11Device), (void**)&g_device);
        g_device->GetImmediateContext(&g_context);
    }

    // acquire backbuffer
    ID3D11Texture2D* backbuffer = nullptr;
    swap->GetBuffer(0, __uuidof(ID3D11Texture2D), (void**)&backbuffer);

    // apply scaler (FSR, XeSS, etc.)
    ScalerManager::Get().ApplyScaler(g_context, backbuffer);

    // cleanup
    if (backbuffer) backbuffer->Release();

    return oPresent(swap, sync, flags);
}

void InstallDX11Hook(void* targetPresent)
{
    MH_Initialize();
    MH_CreateHook(targetPresent, &hkPresent, reinterpret_cast<void**>(&oPresent));
    MH_EnableHook(targetPresent);
}
