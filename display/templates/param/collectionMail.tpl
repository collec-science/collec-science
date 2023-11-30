<h2>{t 1=$collection_name}Collection %1{/t}</h2>
{if !empty($samples)}
<h3>{t}Liste des échantillons dont l'expiration est proche{/t}</h3>
<table>
    <thead>
        <tr>
            <th>UID</th>
            <th>{t}Identifiant{/t}</th>
            <th>{t}Type{/t}</th>
            <th>{t}Date d'échantillonnage{/t}</th>
            <th>{t}Date d'expiration{/t}</th>
        </tr>
    </thead>
    <tbody>
        {foreach $samples as $sample}
        <tr>
            <td>{$sample.uid}</td>
            <td>{$sample.identifier}</td>
            <td>{$sample.sample_type_name}</td>
            <td>{$sample.sampling_date}</td>
            <td>{$sample.expiration_date}</td>
        </tr>
        {/foreach}
    </tbody>
</table>
{/if}

{if !empty($events)}
<h3>{t}Liste des événements à traiter{/t}</h3>
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>{t}UID de l'échantillon{/t}</th>
            <th>{t}Identifiant{/t}</th>
            <th>{t}Type d'échantillon{/t}</th>
            <th>{t}Date d'échéance{/t}</th>
            <th>{t}Type d'événement{/t}</th>
        </tr>
    </thead>
    <tbody>
        {foreach $events as $event}
        <tr>
            <td>{$event.event_id}</td>
            <td>{$event.uid}</td>
            <td>{$event.identifier}</td>
            <td>{$event.sample_type_name}</td>
            <td>{$event.due_date}</td>
            <td>{$event.event_type_name}</td>
        </tr>
        {/foreach}
    </tbody>
</table>
{/if}