import postgres from 'postgres'

const connectionString = process.env.DATABASE_URL
if (!connectionString) {
  throw new Error('DATABASE_URL no está definida. Carga el archivo .env al iniciar Node.')
}

// Supabase port 6543 is transaction pooling; disable prepared statements.
const sql = postgres(connectionString, { prepare: false })

export default sql
