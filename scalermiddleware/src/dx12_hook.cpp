#include "dx12_hook.h"
#include "scaler_manger.h"
#include <d3d12.h>
#include <dxgi1_4.h>
#include <MinHook.h>

typedef void(__stdcall* ExecuteCommandListsFn)(
    ID3D12CommandQueue* queue,
    UINT numLists,
    ID3D12CommandList* const* lists);

ExecuteCommandListFn oExecuteCommandLists = nullptr;

void __stdcall hkExecuteCommandLists(
    ID3D12CommandQueue* queue,
    UINT numLists,
    ID3DCommandList* const* lists)
{
    // detect if this queue is a graphics queue
    D3D12_COMMAND_QUEUE_DESC desc = queue->GetDesc();
    if (desc.Type == D3D12_COMMAND_LIST_TYPE_DIRECT)
    {
        // let the scaler inspect or modify command lists
        ScalerManager::Get().OnDX12CommandLists(queue, lists, numLists);
    }

    // call orginal
    oExecuteCommandLists(queue, numLists, lists);
}

void InstallDX12Hook(void* targetExecute)
{
    MH_Initialize();
    MH_CreateHook(targetExecute, &hkExecuteCommandLists,
                  reinterpret_cast<void**>(&oExecuteCommandLists));
    MH_EnableHook(targetExecute);
}