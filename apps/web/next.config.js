/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  async rewrites() {
    return [
      {
        source: '/api/node/:path*',
        destination: 'http://localhost:26657/:path*',
      },
      {
        source: '/api/gateway/:path*',
        destination: 'http://localhost:3069/:path*',
      },
    ]
  },
}

module.exports = nextConfig
