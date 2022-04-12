using HTTP

Auth = Dict("session" => "53616c7465645f5f9ef634f8a7633d229feef21f367fd663c7d50f9f1378d5ed03fa8dfa0da69fd661239c64c3c69f5e")

function downloadinput(year, day)
    path = "https://adventofcode.com/$year/day/$day/input"
    response = HTTP.request("GET", path; cookies = Auth)
    response.body
end

function getinput(year, day)
    cachepath = "inputs/$year-$day.txt"

    try
        open(f -> read(f, String), cachepath)
    catch
        body = downloadinput(year, day)
        open(f -> write(f, body), cachepath, "w")
        String(body)
    end
end
