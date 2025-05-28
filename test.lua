local ffi = require("ffi")

ffi.cdef([[
	typedef struct NoteInfo
	{
		unsigned int notes;
		float rowTime;
	} NoteInfo;

	typedef struct CalcHandle {} CalcHandle;

	typedef struct Ssr {
		float overall;
		float stream;
		float jumpstream;
		float handstream;
		float stamina;
		float jackspeed;
		float chordjack;
		float technical;
	} Ssr;

	typedef struct MsdForAllRates {
		// one for each full-rate from 0.7 to 2.0 inclusive
		Ssr msds[14];
	} MsdForAllRates;

	int calc_version();

	CalcHandle *create_calc();

	void destroy_calc(CalcHandle *calc);

	MsdForAllRates calc_msd(CalcHandle *calc, const NoteInfo *rows, size_t num_rows, const unsigned int keycount);
	Ssr calc_msd_rate(CalcHandle *calc, const NoteInfo *rows, size_t num_rows, float music_rate, unsigned keycount);
	Ssr calc_ssr(CalcHandle *calc, NoteInfo *rows, size_t num_rows, float music_rate, float score_goal, const unsigned int keycount);
]])

local lib = ffi.load("/media/SSD/Dev/pain/minacalc-standalone/libminacalc.so")
local calc_handle = lib.create_calc()

---@param size number
---@return ffi.cdata*
local function noteInfo(size)
	if not size then
		return ffi.new("NoteInfo")
	end

	return ffi.new("NoteInfo[?]", size)
end

---@param rows ffi.cdata*
---@param row_count number
---@param time_rate number
---@param target_accuracy number
---@param keycount number
---@return table
local function getMsd(rows, row_count, time_rate, keycount)
	local ssr = lib.calc_msd_rate(calc_handle, rows, row_count, time_rate,  keycount)

	return {
		overall = ssr.overall,
		stream = ssr.stream,
		jumpstream = ssr.jumpstream,
		handstream = ssr.handstream,
		stamina = ssr.stamina,
		jackspeed = ssr.jackspeed,
		chordjack = ssr.chordjack,
		technical = ssr.technical,
	}
end

local function bpm(v)
	return 60 / v
end

local function test4k()
	local row_count = 1000
	local bytes = {
		0b0110,
		0b1111,
		0b1011,
		0b1111,
		0b1100,
		0b1111,
		0b0110,
		0b1111,
		0b1001,
		0b1111,
	}

	local rows = noteInfo(row_count)

	for i = 0, 1000 - 1, 1 do
		rows[i].notes = bytes[(i % 10) + 1]
		rows[i].rowTime = i * 0.05
	end

	local ssr = getMsd(rows, row_count, 1.0, 4)
	local overall = ssr.overall
	assert(overall > 30, "RESTART THE GAME!!! MinaCalc is not feeling good for some reason." .. overall)
	print(ssr.overall)
	print("minacalc ok")
end

local function test7k()
	print(" ----- 7K ----- ")
	local row_count = 1000
	local bytes = {
		0b0101010,
		0b1010101,
		0b0001000,
		0b0100010,
		0b1010100,
		0b0100001,
		0b0001010,
	}

	local rows = noteInfo(row_count)

	for i = 0, 1000 - 1, 1 do
		rows[i].notes = bytes[(i % #bytes) + 1]
		rows[i].rowTime = i * (bpm(120) / 4)
	end

	local ssr = getMsd(rows, row_count, 1.0, 8)

	print("streams:", ssr.stream)
	print("brackets:", ssr.handstream)
	print("chordstream:", ssr.jumpstream)
	print("chordjack:", ssr.chordjack)
end

local function test10k()
	print(" ----- 10K ----- ")
	local row_count = 1000
	local bytes = {
		0b0110000011,
		0b1011100000,
		0b0000001010,
		0b0100101010,
		0b0110000001,
		0b0000100001,
		0b1010110100
	}

	local rows = noteInfo(row_count)

	for i = 0, 1000 - 1, 1 do
		rows[i].notes = bytes[(i % #bytes) + 1]
		rows[i].rowTime = i * (bpm(120) / 4)
	end

	print(bpm(120) / 4)

	local ssr = getMsd(rows, row_count, 1.0, 10)

	print("streams:", ssr.stream)
	print("brackets:", ssr.handstream)
	print("chordstream:", ssr.jumpstream)
	print("chordjack:", ssr.chordjack)
end

test4k()
test7k()
test10k()
