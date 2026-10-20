
import "dotenv/config";
import express from "express";
import helmet from "helmet";
import cors from "cors";
import rateLimit from "express-rate-limit";
import { pool } from "./db.js";

const app = express();
const port = Number(process.env.PORT || 3000);

app.disable("x-powered-by");
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_ORIGIN || false
}));
app.use(express.json({ limit: "200kb" }));

app.use("/api", rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 100
}));

app.get("/api/health", async (_req, res) => {
  try {
    await pool.query("SELECT 1");
    res.json({
      ok: true,
      service: "Agro_Modex v8",
      database: "connected"
    });
  } catch {
    res.status(503).json({
      ok: false,
      database: "unavailable"
    });
  }
});

app.get("/api/mods", async (_req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT id, slug, name, game, category,
              version, description, image_url,
              price_cents, currency
       FROM mods
       WHERE status = 'released'
       ORDER BY created_at DESC`
    );

    res.json({ mods: result.rows });
  } catch (error) {
    next(error);
  }
});

app.use((error, _req, res, _next) => {
  console.error(error);
  res.status(500).json({
    error: "Internal server error"
  });
});

app.listen(port, () => {
  console.log(
    `Agro_Modex server listening on port ${port}`
  );
});
