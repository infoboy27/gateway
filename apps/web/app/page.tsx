'use client'

import { useQuery } from '@tanstack/react-query'

interface NodeStatus {
  result: {
    sync_info: {
      latest_block_height: string
      latest_block_time: string
      catching_up: boolean
    }
    node_info: {
      network: string
      version: string
    }
  }
}

export default function Home() {
  const { data: nodeStatus, isLoading, error } = useQuery<NodeStatus>({
    queryKey: ['node-status'],
    queryFn: async () => {
      const response = await fetch('/api/node/status')
      if (!response.ok) {
        throw new Error('Failed to fetch node status')
      }
      return response.json()
    },
    refetchInterval: 5000, // Refetch every 5 seconds
  })

  return (
    <div className="min-h-screen bg-gray-900 text-white">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-4xl font-bold mb-8">Gateway Dashboard</h1>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Node Status Card */}
          <div className="bg-gray-800 rounded-lg p-6">
            <h2 className="text-2xl font-semibold mb-4">Node Status</h2>
            {isLoading && <p>Loading...</p>}
            {error && <p className="text-red-400">Error: {error.message}</p>}
            {nodeStatus && (
              <div className="space-y-2">
                <p><span className="font-medium">Network:</span> {nodeStatus.result.node_info.network}</p>
                <p><span className="font-medium">Version:</span> {nodeStatus.result.node_info.version}</p>
                <p><span className="font-medium">Block Height:</span> {nodeStatus.result.sync_info.latest_block_height}</p>
                <p><span className="font-medium">Latest Block Time:</span> {new Date(nodeStatus.result.sync_info.latest_block_time).toLocaleString()}</p>
                <p><span className="font-medium">Status:</span> 
                  <span className={`ml-2 px-2 py-1 rounded text-sm ${nodeStatus.result.sync_info.catching_up ? 'bg-yellow-600' : 'bg-green-600'}`}>
                    {nodeStatus.result.sync_info.catching_up ? 'Syncing' : 'Synced'}
                  </span>
                </p>
              </div>
            )}
          </div>

          {/* Gateway Status Card */}
          <div className="bg-gray-800 rounded-lg p-6">
            <h2 className="text-2xl font-semibold mb-4">Gateway Status</h2>
            <p className="text-yellow-400">Gateway service is currently disabled</p>
            <p className="text-sm text-gray-400 mt-2">
              The gateway service was temporarily disabled due to configuration issues.
            </p>
          </div>

          {/* Quick Actions Card */}
          <div className="bg-gray-800 rounded-lg p-6">
            <h2 className="text-2xl font-semibold mb-4">Quick Actions</h2>
            <div className="space-y-2">
              <button 
                className="w-full bg-blue-600 hover:bg-blue-700 px-4 py-2 rounded"
                onClick={() => window.open('http://localhost:26657', '_blank')}
              >
                Open Node RPC
              </button>
              <button 
                className="w-full bg-green-600 hover:bg-green-700 px-4 py-2 rounded"
                onClick={() => window.open('http://localhost:3000', '_blank')}
              >
                Open Documentation
              </button>
            </div>
          </div>

          {/* System Info Card */}
          <div className="bg-gray-800 rounded-lg p-6">
            <h2 className="text-2xl font-semibold mb-4">System Info</h2>
            <div className="space-y-2">
              <p><span className="font-medium">Node RPC:</span> localhost:26657</p>
              <p><span className="font-medium">Node gRPC:</span> localhost:9090</p>
              <p><span className="font-medium">Gateway:</span> localhost:3069 (disabled)</p>
              <p><span className="font-medium">Documentation:</span> localhost:3000</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
