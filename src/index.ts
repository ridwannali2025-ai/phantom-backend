import express from "express";
import programRouter from "./routes/program";

const app = express();
app.use(express.json());
app.use("/api", programRouter);

app.listen(process.env.PORT || 3000, () => {
  console.log("Server running");
});

