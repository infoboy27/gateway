import { Providers } from '@/components/providers'
import './globals.css'

export const metadata = {
  title: 'Gateway Dashboard',
  description: 'Pocket Network Shannon Testnet Gateway Dashboard',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  )
}
