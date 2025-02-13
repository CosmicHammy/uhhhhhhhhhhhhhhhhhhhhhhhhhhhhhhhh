document.addEventListener("DOMContentLoaded", async () => {
    const tableBody = document.querySelector("#standingsTable tbody");

    try {
        const response = await fetch("/api/standings");
        const teams = await response.json();

        tableBody.innerHTML = teams.map((team, index) => `
            <tr>
                <td>${index + 1}</td>
                <td>${team.name}</td>
                <td>${team.played}</td>
                <td>${team.won}</td>
                <td>${team.drawn}</td>
                <td>${team.lost}</td>
                <td>${team.goalsFor}</td>
                <td>${team.goalsAgainst}</td>
                <td>${team.goalDifference}</td>
                <td>${team.points}</td>
                <td>${team.form}</td>
            </tr>
        `).join("");
    } catch (error) {
        console.error("Error fetching standings:", error);
    }
});
